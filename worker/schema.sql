-- ΩPair schema v3: friends + post visibility

CREATE TABLE IF NOT EXISTS friendships (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  requester_id INTEGER NOT NULL,
  addressee_id INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',  -- 'pending' | 'accepted' | 'declined'
  created_at INTEGER NOT NULL,
  responded_at INTEGER,
  FOREIGN KEY (requester_id) REFERENCES identities(id),
  FOREIGN KEY (addressee_id) REFERENCES identities(id)
);
CREATE INDEX IF NOT EXISTS idx_friendships_requester ON friendships (requester_id, status);
CREATE INDEX IF NOT EXISTS idx_friendships_addressee ON friendships (addressee_id, status);

ALTER TABLE posts ADD COLUMN visibility TEXT NOT NULL DEFAULT 'public';
