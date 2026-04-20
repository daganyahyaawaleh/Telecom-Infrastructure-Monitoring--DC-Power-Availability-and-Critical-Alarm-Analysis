
WITH ServiceDownEvents AS (
    SELECT
        site_id,
        [timestamp] AS Start_Time
    FROM alarms_data
    WHERE EventType = 'ServiceDown'
),

ServiceRestoreEvents AS (
    SELECT
        site_id,
        [timestamp] AS End_Time
    FROM alarms_data
    WHERE EventType = 'ServiceRestored'
)

SELECT
    ROW_NUMBER() OVER (ORDER BY d.site_id, d.Start_Time) AS Incident_ID,
    d.site_id,
    d.Start_Time,
    MIN(r.End_Time) AS End_Time,
    DATEDIFF(MINUTE, d.Start_Time, MIN(r.End_Time)) / 60.0 AS Duration_Hours
INTO service_incidents
FROM ServiceDownEvents d
LEFT JOIN ServiceRestoreEvents r
    ON d.site_id = r.site_id
   AND r.End_Time > d.Start_Time
GROUP BY d.site_id, d.Start_Time
HAVING MIN(r.End_Time) IS NOT NULL;
