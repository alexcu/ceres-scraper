SELECT
  id,
  timestamp,
  COALESCE(
    (
      client_sentiment_t10 +
      client_sentiment_t20 +
      client_sentiment_t30 +
      client_sentiment_t40 +
      client_sentiment_t50 +
      client_sentiment_t60 +
      client_sentiment_t70 +
      client_sentiment_t80 +
      client_sentiment_t90 +
      client_sentiment_t100
    ),
    (
      mono_sentiment_t10 +
      mono_sentiment_t20 +
      mono_sentiment_t30 +
      mono_sentiment_t40 +
      mono_sentiment_t50 +
      mono_sentiment_t60 +
      mono_sentiment_t70 +
      mono_sentiment_t80 +
      mono_sentiment_t90 +
      mono_sentiment_t100
    )
  ) / 10 AS sentiment_score
FROM Call
WHERE agent = {{agent_name}}
AND call_center_id = {{call_center_id}}
[[AND DATE(timestamp) >= {{date_range_start}}]]
[[AND DATE(timestamp) <= {{date_range_end}}]]
ORDER BY 3 ASC
LIMIT 3;
