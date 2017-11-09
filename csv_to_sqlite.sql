-- Basic Schema

CREATE TABLE Callcenter(
  "id" INTEGER PRIMARY KEY,
  "name" TEXT
);

CREATE TABLE Call(
  "id" TEXT,
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
  "sentiment_t100" REAL,
  "call_center_id" INTEGER,
  PRIMARY KEY (id, call_center_id), -- Composite PK for CC+id
  FOREIGN KEY(call_center_id) REFERENCES Callcenter(id)
);

CREATE TABLE Topic(
  "id" TEXT,
  "description" TEXT
  "call_center_id" INTEGER,
  PRIMARY KEY (id, call_center_id), -- Composite PK for CC+id
  FOREIGN KEY (call_center_id) REFERENCES Callcenter (id)
);

-- Create StarTrack
INSERT INTO Callcenter VALUES (0, 'StarTrack');
INSERT INTO Callcenter VALUES (1, 'NewsCorp');

-- Topics for StarTrack
INSERT INTO Topic VALUES (0, 'Confirmation', 0);
INSERT INTO Topic VALUES (1, 'Customer Service - Investigation', 0);
INSERT INTO Topic VALUES (2, 'Post Office', 0);
INSERT INTO Topic VALUES (3, 'Customer Service Board / Depot', 0);
INSERT INTO Topic VALUES (4, 'Long Hold / Auto-Response', 0);
INSERT INTO Topic VALUES (5, 'Long Hold / Ads', 0);
INSERT INTO Topic VALUES (6, 'Customer Service / Next Flight / Quote', 0);
INSERT INTO Topic VALUES (7, 'Booking Reference', 0);
INSERT INTO Topic VALUES (8, 'Accounts', 0);
INSERT INTO Topic VALUES (9, 'Goods Description', 0);

.mode csv
.import data/startrack.csv startrack
.save data/startrack.sqlite
