
SELECT 
    EventType,
    COUNT(*) AS nb_events
FROM alarms_data
GROUP BY EventType;

-- Insight:
-- Not all AC failures (MainsFail) result in ServiceDown events
-- This confirms the role of battery backup systems
