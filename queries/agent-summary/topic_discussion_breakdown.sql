SELECT t.description AS topic, COUNT(*) AS count
FROM Call c
JOIN Topic t
ON c.most_prominent_topic = t.id
WHERE agent = {{agent_name}}
AND c.call_center_id = {{call_center_id}}
AND t.call_center_id = {{call_center_id}}
[[AND date(c.timestamp) >= {{date_range_start}}]]
[[AND date(c.timestamp) <= {{date_range_end}}]]
GROUP BY t.description
ORDER BY count DESC;
