-- =====================================================
-- Purpose: Detect AC and Service events
-- =====================================================

WITH OrderedData AS (
    SELECT
        site_id,
        [timestamp],
        dc_voltage,
        ac_status,

        LAG(ac_status) OVER (PARTITION BY site_id ORDER BY [timestamp]) AS prev_ac_status,

        LAG(CASE WHEN dc_voltage < 43 THEN 1 ELSE 0 END) 
            OVER (PARTITION BY site_id ORDER BY [timestamp]) AS prev_service_state,

        CASE 
            WHEN dc_voltage < 43 THEN 1 ELSE 0
        END AS current_service_state
    FROM sensor_data_final
),

AC_Events AS (
    SELECT
        site_id,
        [timestamp],
        CASE
            WHEN prev_ac_status = 1 AND ac_status = 0 THEN 'MainsFail'
            WHEN prev_ac_status = 0 AND ac_status = 1 THEN 'MainsRestore'
        END AS EventType
    FROM OrderedData
    WHERE prev_ac_status <> ac_status
),

Service_Events AS (
    SELECT
        site_id,
        [timestamp],
        CASE
            WHEN ISNULL(prev_service_state, 0) = 0 AND current_service_state = 1 THEN 'ServiceDown'
            WHEN ISNULL(prev_service_state, 0) = 1 AND current_service_state = 0 THEN 'ServiceRestored'
        END AS EventType
    FROM OrderedData
    WHERE prev_service_state <> current_service_state
)

SELECT
    site_id,
    [timestamp],
    EventType
INTO alarms_data
FROM (
    SELECT * FROM AC_Events
    UNION ALL
    SELECT * FROM Service_Events
) x
WHERE EventType IS NOT NULL;