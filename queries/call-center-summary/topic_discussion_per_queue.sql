SELECT t.description AS topic, COUNT(*) as number_of_calls
FROM Call c
JOIN Topic t
ON c.most_prominent_topic = t.id
WHERE c.call_center_id = {{call_center_id}}
AND c.call_center_id = t.call_center_id
[[AND date(timestamp) >= {{date_range_start}}]]
[[AND date(timestamp) <= {{date_range_end}}]]
GROUP BY topic
ORDER BY number_of_calls DESC;
