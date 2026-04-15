-- =====================================================
-- Purpose: Clean raw data and pivot to analytical format
-- =====================================================

WITH CleanData AS (
    SELECT 
        TRY_CONVERT(DATETIME2, [timestamp], 120) AS ts,
        CAST(sensor_id AS INT) AS s_id,
        TRY_CAST(REPLACE(value, ',', '.') AS FLOAT) AS val,
        sensor_type
    FROM sensor_raw_log
    WHERE sensor_type <> 'TEMPERATURE'
),

EnrichedData AS (
    SELECT 
        c.ts,
        m.site_id,
        c.sensor_type,
        c.val
    FROM CleanData c
    INNER JOIN sensor_site_mapping_clean m 
        ON c.s_id = m.sensor_id
        AND c.ts >= m.start_date
        AND c.ts <= ISNULL(m.end_date, '9999-12-31')
)

SELECT 
    site_id, 
    ts AS [timestamp], 
    [DC_VOLTAGE], 
    [AC_STATUS]
INTO sensor_data_final
FROM EnrichedData
PIVOT (
    AVG(val) 
    FOR sensor_type IN ([DC_VOLTAGE], [AC_STATUS])
) AS PivotTable;