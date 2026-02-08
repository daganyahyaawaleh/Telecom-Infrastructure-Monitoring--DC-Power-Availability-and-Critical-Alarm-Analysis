

1. CLEANING & TYPE CASTING
-- Converting strings to appropriate numeric and temporal formats
INSERT INTO dbo.Sensors_Clean (SensorID, Value, LogTime)
SELECT 
    TRY_CAST(SensorID AS INT),
    TRY_CAST(REPLACE(Value, ',', '.') AS DECIMAL(18,2)),
    TRY_CAST(LogTime AS DATETIME2(0))
FROM dbo.SensorData
WHERE TRY_CAST(LogTime AS DATETIME2(0)) IS NOT NULL;

-- 2. TIME FILTERING & DATA OBFUSCATION
-- Scoping to Q3/Q4 2025 and adding 10% random noise to protect sensitive values
SELECT 
    SensorID,
    LogTime,
    Value * (0.9 + (0.2 * ABS(CHECKSUM(NEWID())) / 2147483647.0)) AS Value
INTO #TempFiltered
FROM dbo.Sensors_Clean
WHERE LogTime >= '2025-07-01' AND LogTime < '2025-12-01';

-- 3. SENSOR ANONYMIZATION (SENS-XXX)
-- Generating randomized unique Sensor ID 
INSERT INTO dbo.Dim_Sensor_Mapping_Portfolio (OldID, NewID)
SELECT 
    SensorID,
    'SENS-' + RIGHT('000' + CAST(ROW_NUMBER() OVER (ORDER BY NEWID()) AS VARCHAR), 3)
FROM (SELECT DISTINCT SensorID FROM #TempFiltered) AS t;

-- 4. SITE ANONYMIZATION & DIMENSION LOADING
INSERT INTO dbo.Dim_Site (SiteKey, SiteName, Sector, SiteType, PriorityLevel)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Site),
    'SITE-' + RIGHT('00' + CAST(ROW_NUMBER() OVER (ORDER BY Site) AS VARCHAR), 3),
    Sector,
    SiteType,
    PriorityLevel
FROM (SELECT DISTINCT Site, Sector, SiteType, PriorityLevel FROM Sites_Reference) AS s;

-- 5. FINAL FACT TABLE LOAD (Business Rules)
-- Applying Alarm thresholds (<43V) and Data Quality status
INSERT INTO dbo.Fact_Sensor_Alarm (SensorID, SiteKey, LogTime, Date, Value, DataStatus, AlarmFlag)
SELECT 
    Map.NewID,
    S.SiteKey,
    T.LogTime,
    CAST(T.LogTime AS DATE),
    T.Value,
    CASE 
        WHEN T.Value IS NULL THEN 'ERROR: MISSING'
        WHEN T.Value < 0 THEN 'OUTLIER: NEGATIVE'
        ELSE 'VALID'
    END,
    CASE WHEN T.Value < 43 AND T.Value >= 0 THEN 1 ELSE 0 END
FROM #TempFiltered T
JOIN dbo.Dim_Sensor_Mapping_Portfolio Map ON T.SensorID = Map.OldID
JOIN Sites_Reference Si ON T.SensorID = Si.[ID capteur]
JOIN dbo.Dim_Site S ON Si.Site = S.SiteName;

-- 6. ASSET LIFECYCLE CALCULATION
-- Summarizing installation periods per sensor and site
INSERT INTO dbo.Dim_Sensor_Lifecycle (Anonymized_SensorID, SiteKey, StartDate, EndDate, ServiceDurationDays)
SELECT 
    SensorID, 
    SiteKey, 
    MIN(LogTime), 
    MAX(LogTime), 
    DATEDIFF(day, MIN(LogTime), MAX(LogTime))
FROM dbo.Fact_Sensor_Alarm
GROUP BY SensorID, SiteKey;

-- Final cleanup
DROP TABLE #TempFiltered;