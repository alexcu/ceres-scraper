CREATE TABLE Startrack(
  "id" TEXT PRIMARY KEY,
  "timestamp" TEXT,
  "queue" TEXT,
  "agent" TEXT,
  "duration" REAL,
  "num_tokens" INTEGER,
  "most_prominent_topic" TEXT,
  "sentiment_t10" REAL,
  "sentiment_t20" REAL,
  "sentiment_t30" REAL,
  "sentiment_t40" REAL,
  "sentiment_t50" REAL,
  "sentiment_t60" REAL,
  "sentiment_t70" REAL,
  "sentiment_t80" REAL,
  "sentiment_t90" REAL,
  "sentiment_t100" REAL
);

CREATE TABLE Topic(
  "id" TEXT PRIMARY KEY,
  "description" TEXT
);

INSERT INTO Topic VALUES (0, 'Confirmation');
INSERT INTO Topic VALUES (1, 'Customer Service - Investigation');
INSERT INTO Topic VALUES (2, 'Post Office');
INSERT INTO Topic VALUES (3, 'Customer Service Board / Depot');
INSERT INTO Topic VALUES (4, 'Long Hold / Auto-Response');
INSERT INTO Topic VALUES (5, 'Long Hold / Ads');
INSERT INTO Topic VALUES (6, 'Custimer Service / Next Flight / Quote');
INSERT INTO Topic VALUES (7, 'Booking Reference');
INSERT INTO Topic VALUES (8, 'Accounts');
INSERT INTO Topic VALUES (9, 'Goods Description');

.mode csv
.import data/startrack.csv startrack
.save data/startrack.sqlite

-- UPDATE startrack SET sentiment_t10 = NULL WHERE sentiment_t10 = '';
-- UPDATE startrack SET sentiment_t20 = NULL WHERE sentiment_t20 = '';
-- UPDATE startrack SET sentiment_t30 = NULL WHERE sentiment_t30 = '';
-- UPDATE startrack SET sentiment_t40 = NULL WHERE sentiment_t40 = '';
-- UPDATE startrack SET sentiment_t50 = NULL WHERE sentiment_t50 = '';
-- UPDATE startrack SET sentiment_t60 = NULL WHERE sentiment_t60 = '';
-- UPDATE startrack SET sentiment_t70 = NULL WHERE sentiment_t70 = '';
-- UPDATE startrack SET sentiment_t80 = NULL WHERE sentiment_t80 = '';
-- UPDATE startrack SET sentiment_t90 = NULL WHERE sentiment_t90 = '';
-- UPDATE startrack SET sentiment_t100 = NULL WHERE sentiment_t100 = '';

-- UPDATE startrack SET hot_topic_1_name = NULL WHERE hot_topic_1_name = '';
-- UPDATE startrack SET hot_topic_1_value = NULL WHERE hot_topic_1_value = '';
-- UPDATE startrack SET hot_topic_2_name = NULL WHERE hot_topic_2_name = '';
-- UPDATE startrack SET hot_topic_2_value = NULL WHERE hot_topic_2_value = '';
-- UPDATE startrack SET hot_topic_3_name = NULL WHERE hot_topic_3_name = '';
-- UPDATE startrack SET hot_topic_3_value = NULL WHERE hot_topic_3_value = '';
