

-- 1. Staging Table (Raw Ingestion from SSIS)
CREATE TABLE dbo.SensorData (
    SensorID nvarchar(50) NULL,
    Value nvarchar(50) NULL,
    LogTime nvarchar(50) NULL
);

-- 2.Cleaning Table (Typed Data)
CREATE TABLE dbo.Sensors_Clean (
    SensorID int NOT NULL,
    Value decimal(18,2) NULL,
    LogTime datetime2(0) NOT NULL
);

-- 3. Dimension: Sites (Anonymized)

CREATE TABLE dbo.Dim_Site (
    SiteKey int NOT NULL PRIMARY KEY,
    SiteName varchar(15) NULL,
    Sector varchar(50) NULL,
    SiteType varchar(50) NULL,
    PriorityLevel varchar(50) NULL
);

-- 4. Dimension: Sensor Lifecycle (SCD)
-- Tracks the duration of service for each hardware asset per site
CREATE TABLE dbo.Dim_Sensor_Lifecycle (
    Anonymized_SensorID varchar(50),
    SiteKey int,
    StartDate datetime,
    EndDate datetime,
    ServiceDurationDays int
);

-- 5. Final Fact Table

CREATE TABLE dbo.Fact_Sensor_Alarm (
    SensorID varchar(50),
    SiteKey int,
    LogTime datetime,
    Date date,
    Value decimal(18,2),
    DataStatus varchar(50),
    AlarmFlag int
);

-- 6. Mapping Table (Anonymization Audit)

CREATE TABLE dbo.Dim_Sensor_Mapping_Portfolio (
    OldID int,
    NewID varchar(50)
);