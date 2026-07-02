-- ΩPair D1 schema

CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  public_key TEXT NOT NULL UNIQUE,   -- 64-char hex, Ed25519 public key
  jing_x REAL NOT NULL,
  jing_y REAL NOT NULL,
  jing_z REAL NOT NULL,
  created_at INTEGER NOT NULL,       -- unix ms
  last_login_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS nonces (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  public_key TEXT NOT NULL,
  nonce TEXT NOT NULL,
  expires_at INTEGER NOT NULL        -- unix ms
);

CREATE INDEX IF NOT EXISTS idx_nonces_lookup ON nonces (public_key, nonce);
