-- Basic Schema

CREATE TABLE Callcenter(
  "id" INTEGER PRIMARY KEY,
  "name" TEXT
);

CREATE TABLE Call(
  "id" TEXT NOT NULL,
  "timestamp" TEXT NOT NULL,
  "queue" TEXT NOT NULL,
  "agent" TEXT NOT NULL,
  "duration" REAL NOT NULL,
  "num_tokens" INTEGER NOT NULL,
  "most_prominent_topic" TEXT NOT NULL,
  "call_center_id" INTEGER NOT NULL,
  "has_dual_track_sentiment" INTEGER NOT NULL,
  "mono_sentiment_t10" REAL NOT NULL,
  "mono_sentiment_t20" REAL NOT NULL,
  "mono_sentiment_t30" REAL NOT NULL,
  "mono_sentiment_t40" REAL NOT NULL,
  "mono_sentiment_t50" REAL NOT NULL,
  "mono_sentiment_t60" REAL NOT NULL,
  "mono_sentiment_t70" REAL NOT NULL,
  "mono_sentiment_t80" REAL NOT NULL,
  "mono_sentiment_t90" REAL NOT NULL,
  "mono_sentiment_t100" REAL NOT NULL,
  "agent_sentiment_t10" REAL DEFAULT NULL,
  "agent_sentiment_t20" REAL DEFAULT NULL,
  "agent_sentiment_t30" REAL DEFAULT NULL,
  "agent_sentiment_t40" REAL DEFAULT NULL,
  "agent_sentiment_t50" REAL DEFAULT NULL,
  "agent_sentiment_t60" REAL DEFAULT NULL,
  "agent_sentiment_t70" REAL DEFAULT NULL,
  "agent_sentiment_t80" REAL DEFAULT NULL,
  "agent_sentiment_t90" REAL DEFAULT NULL,
  "agent_sentiment_t100" REAL DEFAULT NULL,
  "client_sentiment_t10" REAL DEFAULT NULL,
  "client_sentiment_t20" REAL DEFAULT NULL,
  "client_sentiment_t30" REAL DEFAULT NULL,
  "client_sentiment_t40" REAL DEFAULT NULL,
  "client_sentiment_t50" REAL DEFAULT NULL,
  "client_sentiment_t60" REAL DEFAULT NULL,
  "client_sentiment_t70" REAL DEFAULT NULL,
  "client_sentiment_t80" REAL DEFAULT NULL,
  "client_sentiment_t90" REAL DEFAULT NULL,
  "client_sentiment_t100" REAL DEFAULT NULL,
  PRIMARY KEY (id, call_center_id), -- Composite PK for CC+id
  FOREIGN KEY (call_center_id) REFERENCES Callcenter (id)
  FOREIGN KEY (most_prominent_topic) REFERENCES Topic (id)
);

CREATE TABLE Topic(
  "id" TEXT,
  "description" TEXT,
  "call_center_id" INTEGER,
  PRIMARY KEY (id, call_center_id), -- Composite PK for CC+id
  FOREIGN KEY (call_center_id) REFERENCES Callcenter (id)
);

-- Imports into Call may have blank strings ('') for client/agent sentiment.
-- If this is the case, we need to default them to NULL as sqlite3 does not
-- make empty CSV cells NULL. Refer to https://stackoverflow.com/a/22371910/519967.
UPDATE Call SET agent_sentiment_t10 = NULL WHERE agent_sentiment_t10 = '';
UPDATE Call SET agent_sentiment_t20 = NULL WHERE agent_sentiment_t20 = '';
UPDATE Call SET agent_sentiment_t30 = NULL WHERE agent_sentiment_t30 = '';
UPDATE Call SET agent_sentiment_t40 = NULL WHERE agent_sentiment_t40 = '';
UPDATE Call SET agent_sentiment_t50 = NULL WHERE agent_sentiment_t50 = '';
UPDATE Call SET agent_sentiment_t60 = NULL WHERE agent_sentiment_t60 = '';
UPDATE Call SET agent_sentiment_t70 = NULL WHERE agent_sentiment_t70 = '';
UPDATE Call SET agent_sentiment_t80 = NULL WHERE agent_sentiment_t80 = '';
UPDATE Call SET agent_sentiment_t90 = NULL WHERE agent_sentiment_t90 = '';
UPDATE Call SET agent_sentiment_t100 = NULL WHERE agent_sentiment_t100 = '';
UPDATE Call SET client_sentiment_t10 = NULL WHERE client_sentiment_t10 = '';
UPDATE Call SET client_sentiment_t20 = NULL WHERE client_sentiment_t20 = '';
UPDATE Call SET client_sentiment_t30 = NULL WHERE client_sentiment_t30 = '';
UPDATE Call SET client_sentiment_t40 = NULL WHERE client_sentiment_t40 = '';
UPDATE Call SET client_sentiment_t50 = NULL WHERE client_sentiment_t50 = '';
UPDATE Call SET client_sentiment_t60 = NULL WHERE client_sentiment_t60 = '';
UPDATE Call SET client_sentiment_t70 = NULL WHERE client_sentiment_t70 = '';
UPDATE Call SET client_sentiment_t80 = NULL WHERE client_sentiment_t80 = '';
UPDATE Call SET client_sentiment_t90 = NULL WHERE client_sentiment_t90 = '';
UPDATE Call SET client_sentiment_t100 = NULL WHERE client_sentiment_t100 = '';


-- Create StarTrack
INSERT INTO Callcenter VALUES (0, 'StarTrack');
INSERT INTO Callcenter VALUES (1, 'NewsCorp');

-- Topics for StarTrack
INSERT INTO Topic VALUES
  (0, 'Confirmation', 0),
  (1, 'Customer Service - Investigation', 0),
  (2, 'Post Office', 0),
  (3, 'Customer Service Board / Depot', 0),
  (4, 'Long Hold / Auto-Response', 0),
  (5, 'Long Hold / Ads', 0),
  (6, 'Customer Service / Next Flight / Quote', 0),
  (7, 'Booking Reference', 0),
  (8, 'Accounts', 0),
  (9, 'Goods Description', 0);

-- Topics for NewsCorp
INSERT INTO Topic VALUES
  (0, "'On hold' general message", 1),
  (1, "Advertiser funeral notice", 1),
  (2, "Payment/Information", 1),
  (3, "'On hold' advertisement message", 1),
  (4, "'On hold' uninterpretable", 1),
  (5, "Funeral notice", 1),
  (6, "Cancellation ", 1),
  (7, "Update credit card details", 1),
  (8, "Unidentifiable", 1),
  (9, "Tech support/ Email/ Reset password", 1);

.mode csv
.import data/startrack.csv Call
.import data/newscorp.csv Call
.save data/callcentre.sqlite
