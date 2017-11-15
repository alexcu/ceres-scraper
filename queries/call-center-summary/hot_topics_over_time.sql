SELECT EXTRACT(HOUR FROM timestamp) AS hour_of_day, COUNT(number_of_calls) AS count_of_calls, topic_name
FROM (
    SELECT c.timestamp AS timestamp, COUNT(t.id) AS number_of_calls, t.description AS topic_name
    FROM (
        SELECT t.id AS topic_id, COUNT(*) as number_of_calls
        FROM Call c
        JOIN Topic t
        ON c.most_prominent_topic = t.id
        WHERE c.call_center_id = {{call_center_id}}
        AND t.call_center_id = {{call_center_id}}
        [[AND DATE(timestamp) >= {{date_range_start}}]]
        [[AND DATE(timestamp) <= {{date_range_end}}]]
        GROUP BY topic_id
        ORDER BY number_of_calls DESC
        LIMIT 3
    ) AS _
    JOIN Call c
    ON c.most_prominent_topic = topic_id
    JOIN Topic t
    ON t.id = topic_id
    WHERE c.call_center_id = {{call_center_id}}
    AND t.call_center_id = {{call_center_id}}
    GROUP BY topic_name, timestamp
) AS _
GROUP BY topic_name, hour_of_day;
