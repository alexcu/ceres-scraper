SELECT c.queue AS queue, t.description AS topic, COUNT(*) AS count
FROM Call c
JOIN Topic t
ON c.most_prominent_topic = t.id
WHERE c.call_center_id = {{call_center_id}}
AND t.call_center_id = {{call_center_id}}
[[AND date(timestamp) >= {{date_range_start}}]]
[[AND date(timestamp) <= {{date_range_end}}]]
GROUP BY c.most_prominent_topic, c.queue
ORDER BY count DESC;
