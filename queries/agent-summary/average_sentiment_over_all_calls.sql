SELECT
  pct AS call_duration,
  'Overall' AS type,
  CASE pct
    WHEN 10 THEN AVG(mono_sentiment_t10)
    WHEN 20 THEN AVG(mono_sentiment_t20)
    WHEN 30 THEN AVG(mono_sentiment_t30)
    WHEN 40 THEN AVG(mono_sentiment_t40)
    WHEN 50 THEN AVG(mono_sentiment_t50)
    WHEN 60 THEN AVG(mono_sentiment_t60)
    WHEN 70 THEN AVG(mono_sentiment_t70)
    WHEN 80 THEN AVG(mono_sentiment_t80)
    WHEN 90 THEN AVG(mono_sentiment_t90)
    WHEN 100 THEN AVG(mono_sentiment_t100)
  END AS value
FROM Call, (
  WITH RECURSIVE Percentiles AS (
    SELECT 10 AS pct
    UNION ALL
    SELECT pct + 10
    FROM Percentiles
    WHERE pct < 100
  )
  SELECT pct FROM Percentiles
) AS _
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]
GROUP BY pct

UNION ALL

SELECT
  pct AS call_duration,
  'Client' AS type,
  CASE pct
    WHEN 10 THEN AVG(client_sentiment_t10)
    WHEN 20 THEN AVG(client_sentiment_t20)
    WHEN 30 THEN AVG(client_sentiment_t30)
    WHEN 40 THEN AVG(client_sentiment_t40)
    WHEN 50 THEN AVG(client_sentiment_t50)
    WHEN 60 THEN AVG(client_sentiment_t60)
    WHEN 70 THEN AVG(client_sentiment_t70)
    WHEN 80 THEN AVG(client_sentiment_t80)
    WHEN 90 THEN AVG(client_sentiment_t90)
    WHEN 100 THEN AVG(client_sentiment_t100)
  END AS value
FROM Call, (
  WITH RECURSIVE Percentiles AS (
    SELECT 10 AS pct
    UNION ALL
    SELECT pct + 10
    FROM Percentiles
    WHERE pct < 100
  )
  SELECT pct FROM Percentiles
) AS _
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]
GROUP BY pct

UNION ALL

SELECT
  pct AS call_duration,
  ' Agent' AS type,
  CASE pct
    WHEN 10 THEN AVG(agent_sentiment_t10)
    WHEN 20 THEN AVG(agent_sentiment_t20)
    WHEN 30 THEN AVG(agent_sentiment_t30)
    WHEN 40 THEN AVG(agent_sentiment_t40)
    WHEN 50 THEN AVG(agent_sentiment_t50)
    WHEN 60 THEN AVG(agent_sentiment_t60)
    WHEN 70 THEN AVG(agent_sentiment_t70)
    WHEN 80 THEN AVG(agent_sentiment_t80)
    WHEN 90 THEN AVG(agent_sentiment_t90)
    WHEN 100 THEN AVG(agent_sentiment_t100)
  END AS value
FROM Call, (
  WITH RECURSIVE Percentiles AS (
    SELECT 10 AS pct
    UNION ALL
    SELECT pct + 10
    FROM Percentiles
    WHERE pct < 100
  )
  SELECT pct FROM Percentiles
) AS _
WHERE call_center_id = {{call_center_id}}
[[AND agent = {{agent_name}}]]
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]
GROUP BY pct;
