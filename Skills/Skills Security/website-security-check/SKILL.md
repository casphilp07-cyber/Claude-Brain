---
name: website-security-check
description: Run an external, black-box security check of a live, publicly reachable website or domain — headers, TLS, cookies, CORS, DNS/email-spoofing protection, information disclosure, third-party scripts, and light rate-limiting behavior — with no source-code access. Always trigger this skill when the user asks to check a website's security, audit HTTPS/security headers, gives a URL and asks if it's secure, or runs "/website-security-check". This is passive/GET-based reconnaissance only — no login brute-forcing, no injection payloads, no load testing — and only runs against a domain the user confirms they own or are authorized to test. Every finding is backed by an actual curl/dig output snippet, never a guess; if evidence is ambiguous it is labeled for manual review instead of asserted. For a deep look at the site's own source code, pair this with the app-security-check skill.
tags: [claude-code, skills, security, website-audit, headers, tls]
---

# Website Security Check

An external, black-box audit of a live website — what an unauthenticated visitor or attacker sees from outside, with no access to the source code. If source access is available, `app-security-check` is the deeper complement to this skill, not a replacement.

**Ground rule — authorization first, before any request beyond a plain page load.** Confirm (or reasonably infer, e.g. the user's own product/company domain they've referenced before) that the user owns or is authorized to test the target domain. If it's ambiguous — a third party's site, a domain with no prior context — ask directly before proceeding. This mirrors ordinary authorized-security-testing practice: passive header/DNS checks on your own site are fine to just run; testing someone else's live site needs an explicit yes.

**Ground rule — passive only.** Every step here is a GET/HEAD request, a DNS lookup, or reading page HTML that was already served. No login attempts (real or guessed credentials), no injection payloads sent, no fuzzing, no volume/load testing. The rate-limiting check in step 9 caps itself at a handful of harmless requests for exactly this reason. This skill answers "what does the outside see", not "can I break in" — it is not a penetration test.

**Ground rule — explain, don't just report.** Every finding gets: (a) what's actually missing, with the real header value/curl output as proof, (b) what an attacker could concretely do with that gap, and (c) what adding the fix actually buys once applied.

## Workflow

Run these with real `curl`/`dig` calls — never fabricate what a header or DNS record says.

### 1. Reachability & TLS

```bash
curl -sS -D - -o /dev/null "http://TARGET/"
curl -sS -D - -o /dev/null "https://TARGET/"
curl -vI "https://TARGET/" 2>&1 | grep -Ei 'expire|subject|issuer|SSL certificate'
```

Check: does HTTP redirect to HTTPS? Is `Strict-Transport-Security` present, and with a meaningful `max-age`? Is the certificate valid and not close to expiry?

### 2. Security headers

```bash
curl -sSI "https://TARGET/"
```

Check presence and value of: `Content-Security-Policy`, `X-Content-Type-Options`, `X-Frame-Options` / CSP `frame-ancestors`, `Referrer-Policy`, `Permissions-Policy`. Quote the actual header line (or its absence) for each — don't summarize as "headers are missing" without naming which ones.

### 3. Cookies

```bash
curl -sSI "https://TARGET/" | grep -i '^set-cookie'
```

If a session/auth cookie is visible without logging in (or the user can point to a login page to check), confirm `Secure`, `HttpOnly`, and `SameSite` flags are set.

### 4. CORS

```bash
curl -sSI -H "Origin: https://evil-example.test" "https://TARGET/api/whatever-endpoint-exists"
```

Look for `Access-Control-Allow-Origin` reflecting an arbitrary origin, especially combined with `Access-Control-Allow-Credentials: true` — that combination lets any website read authenticated responses.

### 5. Information disclosure

Test a small, fixed allowlist of common paths — GET-only, low volume, not a fuzzing sweep:

```bash
for p in /.env /.git/config /.git/HEAD /wp-config.php.bak /server-status /robots.txt /sitemap.xml; do
  echo "== $p =="; curl -sS -o /dev/null -w '%{http_code}\n' "https://TARGET$p"
done
```

A 200 on `/.env`, `/.git/config`, or a backup file is a real finding — fetch it to confirm it actually contains something sensitive before reporting CRITICAL. Also request something guaranteed not to exist (`/this-should-not-exist-12345`) and a request likely to 500 if possible, to see whether error pages leak stack traces, file paths, or framework/version details.

### 6. DNS / email-spoofing protection

```bash
dig +short TXT TARGET | grep -i spf
dig +short TXT _dmarc.TARGET
dig +short TXT default._domainkey.TARGET
```

Missing SPF/DMARC means anyone can spoof email "from" this domain — relevant even for a site with no visible email feature, since the domain itself is still spoofable. If the user names specific subdomains, check for dangling CNAMEs (a CNAME pointing at a provider — GitHub Pages, S3, Heroku, etc. — where nothing is actually provisioned) as a subdomain-takeover signal.

### 7. Third-party scripts

```bash
curl -sS "https://TARGET/" | grep -Eo '<script[^>]*src="[^"]*"'
```

List external script origins. Flag scripts loaded without Subresource Integrity (`integrity=`) from third-party (non-first-party, non-major-CDN) origins — a compromised third-party script is a direct XSS/data-theft vector on every page that loads it.

### 8. Forms

Pull the page HTML and check visible `<form>` tags: submit over HTTPS, a CSRF token field present for state-changing forms, no `autocomplete="on"` left default on password fields where it shouldn't be.

### 9. Rate-limiting signal (capped, non-disruptive)

Send 3-5 harmless GET requests in quick succession to a public, non-destructive endpoint and note whether a `429` or challenge page appears. This is a signal, not a real test of brute-force protection — say so. **Never** repeat this against a login endpoint with real or guessed credentials.

## Output format

```
[STATUS] Category
Evidence: <the real header value / curl output / dig output, quoted>
What's missing: <the gap, in plain language>
Attack scenario: <what this lets an attacker do>
If fixed: <what protection this buys>
```

`STATUS` is PASS / WARN / FAIL per category. Close with:
- **Overall risk: High / Medium / Low** — one line justifying it from the categories above.
- A prioritized fix list: the exact header/config line to add, and where it likely goes if the stack is identifiable from response headers (e.g. `Server`, `X-Powered-By`) — Nginx config, a Next.js `next.config.js`/middleware, a Cloudflare Transform Rule, etc. If the stack isn't identifiable, say the header/value and let the owner place it.

## Limitations — say these out loud when they matter

- This is an unauthenticated, external view only. It cannot see server-side code, so it cannot find injection, IDOR, or auth-logic bugs that don't manifest in what's served publicly — that's what `app-security-check` is for.
- A WAF or CDN in front of the origin can mask or alter real origin behavior (headers, error pages) — note when Cloudflare/similar is detected, since some findings may reflect the edge, not the origin server.
- DNS-based checks (SPF/DMARC/DKIM) require records to have propagated and depend on the resolver used; a missing record here is still worth flagging even if a different resolver shows something cached.
- The rate-limiting check is a light signal from a handful of requests, not a real brute-force resistance test.
- Not a substitute for a licensed external penetration test for a site handling payments, health data, or other regulated data.
