SELECT AVG(duration)
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]];
