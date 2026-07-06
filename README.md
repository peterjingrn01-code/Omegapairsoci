# ΩPair — Edit Username Update

This update adds the ability for users to change their display username
(handle), plus keeps the "remember login" feature from before.

## What's inside

```
index.html        ← new frontend, replaces the one on GitHub
worker-index.js    ← new backend, replaces the code in your Cloudflare Worker
```

No database changes needed this time — the `identities` table already
has a `handle` column, this just adds a way to update it.

## Deploy in this order

### 1. Backend (Cloudflare Worker)

Workers & Pages → `omegapair-api` → **Edit code** → select all, delete,
paste in `worker-index.js` → **Deploy**.

### 2. Frontend (GitHub)

Rename `index.html` if needed, then on GitHub: **Add file → Upload
files** → select it → confirm replacing the existing file → **Commit
changes**.

## What's new

- A small ✎ pencil icon next to your username in the top bar. Click it,
  type a new username (3-20 characters: letters, numbers, dots,
  underscores, or hyphens), click **Save**.
- Usernames must be unique — if someone already has it, you'll see an
  error and can pick another.
- Changing your username only affects new posts going forward — posts
  you already made will still show your old username underneath them.
  This is normal behavior (most social platforms work this way).
