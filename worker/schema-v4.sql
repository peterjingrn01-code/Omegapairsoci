-- ΩPair schema v4: OmegaPair Token (OPT) — Genesis + hash-chain ledger

-- Proof of pair: Ω₀ = hash(username, email, phone)
ALTER TABLE identities ADD COLUMN profile_email TEXT;
ALTER TABLE identities ADD COLUMN profile_phone TEXT;
ALTER TABLE identities ADD COLUMN pair_hash TEXT;

-- Balances (materialized for fast lookup)
CREATE TABLE IF NOT EXISTS balances (
  identity_id INTEGER PRIMARY KEY,
  balance INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (identity_id) REFERENCES identities(id)
);

-- The ledger itself: a hash chain. Ω₀ = genesis, Ω₁, Ω₂, ... each entry's
-- hash incorporates the previous entry's hash, so tampering with any past
-- entry breaks every hash after it.
CREATE TABLE IF NOT EXISTS ledger (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  seq INTEGER NOT NULL,
  prev_hash TEXT,
  entry_hash TEXT NOT NULL,
  from_identity_id INTEGER,           -- NULL for genesis mint
  to_identity_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  memo TEXT,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (from_identity_id) REFERENCES identities(id),
  FOREIGN KEY (to_identity_id) REFERENCES identities(id)
);
CREATE INDEX IF NOT EXISTS idx_ledger_seq ON ledger (seq);
CREATE INDEX IF NOT EXISTS idx_ledger_to ON ledger (to_identity_id);
CREATE INDEX IF NOT EXISTS idx_ledger_from ON ledger (from_identity_id);
