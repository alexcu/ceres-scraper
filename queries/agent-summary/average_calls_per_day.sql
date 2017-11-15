SELECT AVG(calls_per_day) AS average_calls_per_day
FROM (
    SELECT agent, COUNT(*) AS calls_per_day
    FROM Call
    WHERE call_center_id = {{call_center_id}}
    [[AND agent = {{agent_name}}]]
    [[AND DATE(timestamp) >= {{date_range_start}}]]
    [[AND DATE(timestamp) <= {{date_range_end}}]]
    GROUP BY agent, DATE(timestamp)
) AS _;
