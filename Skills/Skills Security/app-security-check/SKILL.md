---
name: app-security-check
description: Run a static security audit on a local app/codebase — web app, backend/API, or native iOS/Android/React Native/Flutter app — before it ships or whenever the owner wants a health check. Always trigger this skill when the user asks to check an app for security issues, audit a codebase for vulnerabilities, run a security review before launch/deploy, asks "is my app secure", or runs "/app-security-check". Covers broken authentication, missing authorization/IDOR, exposed secrets, SQL/NoSQL/command/code injection, XSS, missing rate limiting, insecure file uploads, security misconfiguration, AI/LLM prompt-injection risk, CSRF, SSRF, dependency CVEs, and — when the project is a native or cross-platform mobile app — iOS and Android specific risks (Keychain/Keystore misuse, exported components, ATS/cleartext traffic, WebView bridges). Every finding must be backed by an actual file:line quote from the code, never a guess; findings the scan can't confirm in context are labeled for manual review instead of asserted.
tags: [claude-code, skills, security, code-audit, static-analysis]
---

# App Security Check

A static security audit of a local codebase, run before a launch/deploy or whenever the owner wants a health check. "App" is not assumed to mean "web app" — the first workflow step identifies the actual platform(s) present (web, iOS, Android, React Native, Flutter, backend-only) and applies the checklist sections that are actually relevant.

**Ground rule: nothing from the app is executed.** Read and grep only — no `npm run`, no starting a server, no running the app's own scripts — unless the user explicitly asks for a specific, scoped command that runs in their own project (e.g. a dependency-CVE scanner like `npm audit`/`pip-audit`).

**Ground rule: every finding needs a receipt.** This skill exists so Caspar can trust the output without re-checking it himself. Never report a finding you have not personally read in its surrounding context. If the scanner script flags something but you can't confirm from the actual code whether it's exploitable (e.g. it's in a test fixture, or the value is clearly a placeholder), mark it PLAUSIBLE / needs manual review — do not round it up to CONFIRMED.

**Ground rule: explain, don't just report.** Every finding gets three things in plain language, not just a severity tag: (a) what is actually missing or wrong, with the file:line proof, (b) the concrete attack scenario — what a real attacker could do with it, and (c) what the proposed fix actually buys once applied. A bare "CRITICAL: hardcoded secret, file.js:12" is not an acceptable finding on its own.

## Workflow

### 1. Scope & recon, including platform detection

Before touching any checklist, understand what you're looking at:
- Tech stack: read `package.json` / `requirements.txt` / `Gemfile` / `go.mod` / `composer.json` / `pubspec.yaml` / `*.csproj` etc. to identify framework, auth provider (Supabase/Clerk/Firebase/Auth0/custom), hosting hints, and ORM/query layer.
- Route/API surface: map the app's routes, API endpoints, and server actions — you need this map for the authorization step later.
- Platform detection (a project can be more than one of these — apply every relevant branch below):
  - **Web** — default assumption if none of the below are found.
  - **iOS native** — `*.xcodeproj`, `*.xcworkspace`, `Info.plist`, `Podfile`, or `Package.swift` present.
  - **Android native** — `AndroidManifest.xml`, `build.gradle`, or `build.gradle.kts` present.
  - **Cross-platform** — React Native (`package.json` depends on `react-native`) or Flutter (`pubspec.yaml` present). Apply both the relevant native branch (if native modules/ios//android folders exist) and the JS/Dart injection/secrets checks.

### 2. Run the scanner

```bash
bash ~/.claude/skills/app-security-check/scripts/scan.sh /path/to/app
```

It greps deterministically for: hardcoded credentials, secrets shipped to the client bundle (`NEXT_PUBLIC_`/`VITE_`/etc. prefixes on secret-sounding names), `.env` files tracked by git, SQL/NoSQL/command/code injection shapes, unsanitized HTML/DOM sinks (XSS), disabled TLS verification, unsafe deserialization, CORS wildcard+credentials, debug-mode flags, weak hashing, insecure randomness for tokens, open redirects — plus, when it detects an iOS or Android project, platform-specific patterns (ATS disabled, secrets in UserDefaults/plist, exported Android components, cleartext traffic, `addJavascriptInterface`, `allowBackup`). Exit code 20 = CRITICAL/HIGH present, 10 = only MEDIUM/LOW, 0 = clean scan.

**Read every flagged line in its actual file — don't just report the scanner's counts.** The scanner finds shapes, not verdicts: a `sk_live_` string in a test fixture, a `.env.example` misnamed without the `.example` suffix, or an `eval()` in a sandboxed template engine are not the same as a live credential or real RCE path. Confirm before reporting CRITICAL/HIGH.

### 3. Authorization & IDOR (manual — not greppable reliably)

For every route/server action found in step 1 that takes an ID (user ID, order ID, document ID, account ID):
- Confirm the identity used for the ownership check comes from the authenticated server session, not from a client-supplied field.
- Confirm there's an explicit ownership/role check before the data is read, written, or deleted — not just an "is logged in" check.
- Spot-check by tracing one or two representative routes end-to-end (route → auth check → DB query) rather than assuming a pattern holds everywhere.

### 4. Authentication & session handling (manual)

Check login, signup, logout, password reset, and session handling: are these routes protected server-side (not only hidden in the frontend)? Does logout actually invalidate the session server-side? Do password-reset tokens expire and work only once? Are error messages generic enough to not leak which emails are registered?

### 5. File uploads (manual, if the app accepts uploads)

Type/content validated server-side (not just by filename/extension), size-limited, stored outside any executable/public code path, private files gated by ownership, no user-controlled storage path (path traversal).

### 6. Rate limiting (manual)

Login, signup, password-reset, OTP, contact forms, and any endpoint that costs money (AI calls, paid APIs, email sends) — confirm server-side limits exist per user and per IP, not just a frontend debounce.

### 7. AI/LLM features, if present

If the app has an AI feature: is user input / retrieved content clearly separated from trusted system instructions? Are tool calls permission-checked in normal server code rather than trusted to the model's judgment? Are secrets kept out of prompts?

### 8. Gaps the scanner and the common checklist both miss

Check explicitly for: CSRF protection on state-changing forms, SSRF in any server-side fetch that takes a user-supplied URL, webhook signature verification, dependency CVEs (if a lockfile exists, offer to run the ecosystem's audit command — e.g. `npm audit`, `pip-audit` — as a scoped, local, non-destructive command), and business-logic flaws such as price/quantity fields trusted from the client instead of recomputed server-side.

### 9. iOS-specific (only if detected in step 1)

Beyond what the scanner already flagged: App Transport Security exceptions justified? Secrets in Keychain, not `UserDefaults`/plist? Sensitive files use appropriate `NSFileProtection`? `WKWebView` doesn't expose a JS bridge to arbitrary/untrusted page content? URL scheme / Universal Link handlers validate input instead of acting on it blindly? Push payloads don't carry sensitive data in cleartext? Face ID/Touch ID is bound to Keychain access control, not just a UI gate that can be bypassed by calling the underlying action directly?

### 10. Android-specific (only if detected in step 1)

Beyond what the scanner already flagged: exported components actually need to be exported, and are permission-protected if so? Cleartext traffic disabled via Network Security Config? No `addJavascriptInterface` bridging into a WebView that can load untrusted content? Intent/deep-link data validated, not trusted blindly? `allowBackup`/`dataExtractionRules` don't expose sensitive data? Release build uses ProGuard/R8? Requested permissions are minimal and each one is justified by an actual feature?

### 11. Cross-platform (React Native/Flutter, only if detected)

The JS bundle / compiled Dart code ships to the device and can be extracted (unzip an APK/IPA) — confirm no secrets are embedded there, same bar as a web frontend bundle. Native bridges/platform channels validate what comes from the JS/Dart side exactly like a normal API boundary would. Apply the web injection/XSS checks (steps in the scanner) to the JS/Dart layer in addition to the native checks above if native modules are present.

## Output format

Each finding, in this shape:

```
[SEVERITY] Short title
File: path/to/file.ext:LINE
What's missing: <the actual gap, in one or two sentences, with the quoted line>
Attack scenario: <what a real attacker does with this, concretely>
If fixed: <what protection this buys — stated plainly, not "improves security">
Confidence: CONFIRMED (read in context) / PLAUSIBLE (needs manual review — say why)
```

Report every finding through the `ReportFindings` tool alongside the prose above — use its `file`/`line`/`summary`/`failure_scenario` fields (the attack scenario goes in `failure_scenario`) and set `verdict` to CONFIRMED or PLAUSIBLE per the confidence rule above. `ReportFindings` gives Caspar a scannable table; the prose right before it is where the "what's missing / what the fix buys" explanation lives.

**Severity rubric:**
- **CRITICAL** — exploitable right now, no special access needed: live exposed credentials, unauthenticated RCE-shaped code, secrets shipped to the client.
- **HIGH** — exploitable with a plausible precondition: injection reachable from user input, missing authorization on a sensitive route, disabled TLS verification.
- **MEDIUM** — a real gap but needs a more specific setup to bite, or is a defense-in-depth control: CORS misconfiguration, debug flags, weak hashing, missing rate limiting on a non-critical endpoint.
- **LOW** — hardening/best-practice, unlikely to be the primary path to a breach on its own.
- **INFO** — observation, no action required (e.g. no `.env.example` present).

## After reporting

Ask whether to apply fixes — don't fix automatically. If yes:
- Never "fix" a leaked credential by rotating it yourself — you can't; state clearly which credentials the owner must rotate manually in the provider's dashboard, and where they were found.
- Apply code fixes file by file, keep existing design/behavior intact, and say exactly what changed and in which files, same as the audit report.
- If tests exist, run them after fixing to confirm nothing broke.

## Limitations — say these out loud when they matter

- Static analysis finds known *shapes* of problems. It does not find novel business-logic flaws, and a clean scan is a snapshot, not a guarantee — the codebase can regress on the next commit.
- Authorization, session, upload, and rate-limiting checks in this skill are manual reasoning over the code, not grep — they depend on you actually tracing representative routes, not pattern-matching. Say so if you only had time to spot-check a subset.
- Dependency/CVE coverage is only as good as the lockfile and whatever audit command actually ran — it does not catch vulnerabilities in code the app vendors directly.
- Mobile checks here are static only — no runtime instrumentation (Frida/Objection), no reverse engineering of a compiled binary/APK. A native app aimed at a hostile audience (e.g. handling payments) may still warrant a dedicated mobile pentest.
- Not a substitute for a professional penetration test for anything handling payments, health data, or other regulated data.
