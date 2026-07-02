# ΩPair — Deployment Guide

This project has two parts:

- **`index.html`** — the frontend (static, no build step). Deployed via **Cloudflare Pages**.
- **`worker/`** — the backend API (challenge/verify/session). Deployed via **Cloudflare Workers** + **D1**.

Auth model: Ed25519 challenge-response. Your private key is generated in the browser and never leaves it. The backend only ever sees your public key and a signature.

---

## 0. Prerequisites

```bash
npm install -g wrangler
wrangler login
```

---

## 1. Push this project to GitHub

```bash
cd omegapair-app
git init
git add .
git commit -m "Initial ΩPair prototype: Ed25519 wallet auth"
git branch -M main
git remote add origin https://github.com/<your-username>/omegapair-app.git
git push -u origin main
```

---

## 2. Deploy the backend (Worker + D1)

```bash
cd worker

# Create the D1 database
wrangler d1 create omegapair-db
```

Copy the `database_id` from the output into `wrangler.toml` (replace `REPLACE_WITH_YOUR_D1_DATABASE_ID`).

```bash
# Apply the schema
wrangler d1 execute omegapair-db --file=./schema.sql --remote

# Set the session-signing secret (pick any long random string)
wrangler secret put SESSION_SECRET
# paste a random string when prompted, e.g. generate one with:
#   openssl rand -hex 32

# Deploy
wrangler deploy
```

Wrangler will print your Worker URL, e.g. `https://omegapair-api.<your-subdomain>.workers.dev`. **Save this.**

---

## 3. Point the frontend at the backend

Open `index.html` and find this line near the top of the `<script>` block:

```js
const API_BASE = "__API_BASE__";
```

Replace it with your actual Worker URL:

```js
const API_BASE = "https://omegapair-api.<your-subdomain>.workers.dev";
```

Commit and push this change.

---

## 4. Deploy the frontend to Cloudflare Pages

**Option A — via dashboard (easiest):**
1. Cloudflare dashboard → Workers & Pages → Create → Pages → Connect to Git
2. Select your `omegapair-app` GitHub repo
3. Build settings: **no build command**, output directory = `/` (root), since `index.html` is static
4. Deploy

**Option B — via CLI:**
```bash
cd omegapair-app
wrangler pages deploy . --project-name=omegapair-app
```

Cloudflare will give you a URL like `https://omegapair-app.pages.dev`.

---

## 5. Close the loop: CORS

Go back to `worker/wrangler.toml` and set:

```toml
[vars]
FRONTEND_ORIGIN = "https://omegapair-app.pages.dev"
```

Then redeploy the worker:

```bash
cd worker
wrangler deploy
```

This restricts the API to only accept requests from your actual frontend domain.

---

## 6. Test it

Open your Pages URL, click **Create new ΩPair wallet**, save the recovery phrase, click connect. If everything is wired correctly you'll land on the feed screen with a real session token issued by your Worker.

You can verify the user was actually written to D1:

```bash
wrangler d1 execute omegapair-db --command="SELECT public_key, jing_x, jing_y, jing_z, created_at FROM users;" --remote
```

---

## What's real vs. still a demo

**Real:**
- Ed25519 keypair generation and signing (native Web Crypto API, no external libraries)
- Challenge-response login — the server never sees your private key, only a signature
- Session tokens (HMAC-signed, checked server-side)
- User records persisted in D1

**Still a demo / not production-hardened:**
- Recovery phrase uses a small custom 16×16 wordlist (128 bits of entropy) — not standard BIP-39, and not yet audited
- Email login is UI-only; no real verification email is sent
- Posts/feed are stored only in browser memory, not in D1 — refreshing the page resets them
- No rate limiting on `/api/challenge` (worth adding before any public launch, to prevent nonce-spam)
- `wrangler.toml`'s CORS is origin-based only; consider additional bot/abuse protection (e.g. Cloudflare Turnstile) before going public

---

## Ed25519 browser support note

This relies on native `crypto.subtle` support for the `"Ed25519"` algorithm, available in recent Chrome, Edge, and Firefox. Safari support has historically lagged — test on your target browsers before relying on this for real users. Cloudflare Workers (workerd) also needs a reasonably current runtime for Ed25519 `verify` support server-side; if `wrangler deploy` or signature verification errors out, check the Workers changelog for Ed25519/WebCrypto support status.
