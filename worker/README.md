# ΩPair — Peer-to-peer OPT transfer + "Edit" label

No database changes this time.

## What changed

1. **Anyone can now send OPT to anyone else** (not just the treasury
   account) — as long as they have enough balance. The "Send OPT" box
   in the Wallet panel now shows for every logged-in user once genesis
   has happened, not just the treasury account.
2. Added a visible **"Edit"** text label next to the ✎ pencil icon by
   the username, so it's more obvious it's clickable.

## Deploy in this order

### 1. Backend (Cloudflare Worker)

Workers & Pages → `omegapair-api` → **Edit code** → select all, delete,
paste in `worker-index.js` → **Deploy**.

### 2. Frontend (GitHub)

Rename `index.html` if needed, then: **Add file → Upload files** →
select it → confirm replacing the existing file → **Commit changes**.

## Note

Since transfers are now open to everyone, anyone who receives OPT from
the treasury can immediately re-send it to someone else. This is normal
for any ledger/currency system — just flagging it so it's not a
surprise.
