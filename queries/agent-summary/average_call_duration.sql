SELECT AVG(duration)
FROM Call
WHERE agent = {{agent_name}}
AND call_center_id = {{call_center_id}}
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]];
