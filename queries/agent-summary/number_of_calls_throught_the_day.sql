SELECT strftime('%H', timestamp) AS hour_of_day, COUNT(*) AS number_of_calls
FROM Call
WHERE agent = {{agent_name}}
AND call_center_id = {{call_center_id}}
[[AND date(timestamp) >= {{date_range_start}}]]
[[AND date(timestamp) <= {{date_range_end}}]]
GROUP BY strftime('%H', timestamp);
