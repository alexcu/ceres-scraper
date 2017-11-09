SELECT AVG(sentiment_score)
FROM (
    SELECT (
        sentiment_t10 +
        sentiment_t20 +
        sentiment_t30 +
        sentiment_t40 +
        sentiment_t50 +
        sentiment_t60 +
        sentiment_t70 +
        sentiment_t80 +
        sentiment_t90 +
        sentiment_t100
    ) / 10 AS sentiment_score
    FROM Call
    WHERE agent = {{agent_name}}
    AND call_center_id = {{call_center_id}}
    [[AND DATE(timestamp) >= {{date_range_start}}]]
    [[AND DATE(timestamp) <= {{date_range_end}}]]
);
