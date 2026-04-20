
SELECT 
    CAST(sensor_id AS INT) AS sensor_id,
    site_id, 
    TRY_CONVERT(DATETIME2, start_date, 120) AS start_date,
    TRY_CONVERT(DATETIME2, end_date, 120) AS end_date
INTO sensor_site_mapping_clean
FROM sensor_site_mapping
WHERE sensor_id IS NOT NULL;
