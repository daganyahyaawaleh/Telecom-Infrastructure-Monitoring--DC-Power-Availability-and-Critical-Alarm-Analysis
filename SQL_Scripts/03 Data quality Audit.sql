-- =============================================================================
-- STEP 3: DATA QUALITY AUDIT REPORT
-- =============================================================================

SELECT 
    DataStatus,
    COUNT(*) AS RecordCount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage
FROM Fact_Sensor_Alarm
GROUP BY DataStatus;

