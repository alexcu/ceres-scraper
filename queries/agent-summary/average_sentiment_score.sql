SELECT
    -- If we support agent_sentiment_score then use that, else default to mono
    COALESCE(AVG(agent_sentiment_score), AVG(mono_sentiment_score)) AS sentiment_score
FROM (
    SELECT (
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
    ) / 10 AS mono_sentiment_score,
    (
        agent_sentiment_t10 +
        agent_sentiment_t20 +
        agent_sentiment_t30 +
        agent_sentiment_t40 +
        agent_sentiment_t50 +
        agent_sentiment_t60 +
        agent_sentiment_t70 +
        agent_sentiment_t80 +
        agent_sentiment_t90 +
        agent_sentiment_t100
    ) / 10 AS agent_sentiment_score
    FROM Call
    WHERE call_center_id = {{call_center_id}}
    [[AND agent = {{agent_name}}]]
    [[AND DATE(timestamp) >= {{date_range_start}}]]
    [[AND DATE(timestamp) <= {{date_range_end}}]]
) AS _;
