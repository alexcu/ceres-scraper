-- Need to "pivot" the times from columns to row...
-- Only way to do this in SQL


SELECT 0.1
AS "time", AVG(sentiment_t10) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]

UNION

SELECT 0.2 AS "time", AVG(sentiment_t20) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]

UNION

SELECT 0.3 AS "time", AVG(sentiment_t30) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]

UNION

SELECT 0.4 AS "time", AVG(sentiment_t40) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]

UNION

SELECT 0.5 AS "time", AVG(sentiment_t50) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]

UNION

SELECT 0.6 AS "time", AVG(sentiment_t60) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]

UNION

SELECT 0.7 AS "time", AVG(sentiment_t70) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]

UNION

SELECT 0.8 AS "time", AVG(sentiment_t80) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]

UNION

SELECT 0.9 AS "time", AVG(sentiment_t90) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]

UNION

SELECT 1.0 AS "time", AVG(sentiment_t100) AS "sentiment"
FROM Call
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]];
