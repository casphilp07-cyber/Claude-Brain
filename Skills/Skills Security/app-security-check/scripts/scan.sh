#!/usr/bin/env bash
#
# scan.sh — static pattern scanner for the app-security-check skill.
#
#   usage:  bash scan.sh <path-to-app>
#
#   exit:   0   nothing flagged
#          10   only MEDIUM / LOW findings
#          20   at least one CRITICAL or HIGH finding
#          64   usage error
#          66   path is not a directory
#
# Deterministic grep pass over the codebase. Every hit is a LEAD, not a
# verdict — the skill reads each flagged line in context afterwards and only
# reports it as CONFIRMED once it has actually seen the surrounding code.
# This script never executes anything from the scanned app — read-only greps.
#
#   env:    SCAN_MAX_HITS  lines printed per finding (default 12)
#           SCAN_CUT       max chars per printed line (default 200)

set -uo pipefail

TARGET="${1:-}"
[ -n "$TARGET" ] || { echo "usage: bash scan.sh <path-to-app>" >&2; exit 64; }
[ -d "$TARGET" ] || { echo "scan.sh: not a directory: $TARGET" >&2; exit 66; }

cd "$TARGET" || exit 66
APP_ABS="$(pwd -P)"

MAX_HITS="${SCAN_MAX_HITS:-12}"
CUT="${SCAN_CUT:-200}"

FILELIST="$(mktemp -t appsecscan.XXXXXX)"
trap 'rm -f "$FILELIST"' EXIT

n_crit=0
n_high=0
n_med=0
n_low=0

# ---------------------------------------------------------------- file list --
find . \
  \( -name .git -o -name node_modules -o -name .venv -o -name venv \
     -o -name site-packages -o -name __pycache__ -o -name .mypy_cache \
     -o -name .pytest_cache -o -name .gradle -o -name .terraform \
     -o -name build -o -name dist -o -name .next -o -name Pods \
     -o -name DerivedData -o -name .dart_tool \) -prune -o \
  -type f \
  ! -name '*.map' ! -name 'package-lock.json' ! -name 'yarn.lock' \
  ! -name 'pnpm-lock.yaml' ! -name 'poetry.lock' ! -name 'Cargo.lock' \
  ! -name 'composer.lock' ! -name 'go.sum' ! -name 'Gemfile.lock' \
  -print0 > "$FILELIST" 2>/dev/null

n_files="$(tr -cd '\0' < "$FILELIST" | wc -c | tr -d ' ')"

echo "app-security-check scanner"
echo "  target : $APP_ABS"
echo "  files  : $n_files scanned (vendored/build dirs and lock files excluded)"

if [ "$n_files" -eq 0 ]; then
  echo
  echo "Nothing to scan — the directory has no regular files."
  exit 0
fi

# ------------------------------------------------------------------ helpers --
gsearch() { # gsearch <pattern...> -> matching "path:line:text" lines
  local pats=() p
  for p in "$@"; do pats+=(-e "$p"); done
  xargs -0 grep -I -H -n -E "${pats[@]}" < "$FILELIST" 2>/dev/null
}

bump() {
  case "$1" in
    CRIT) n_crit=$((n_crit + 1)) ;;
    HIGH) n_high=$((n_high + 1)) ;;
    MED)  n_med=$((n_med + 1))   ;;
    *)    n_low=$((n_low + 1))   ;;
  esac
}

emit() { # emit <sev> <label> <hint> <output>
  local sev="$1" label="$2" hint="$3" out="$4" total
  [ -n "$out" ] || return 0
  total="$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
  printf '\n[%s] %s — %s hit(s)\n' "$sev" "$label" "$total"
  [ -n "$hint" ] && printf '      why it matters: %s\n' "$hint"
  printf '%s\n' "$out" | head -n "$MAX_HITS" | cut -c1-"$CUT" | sed -e 's|^\./||' -e 's|^|  |'
  [ "$total" -gt "$MAX_HITS" ] && printf '  ... and %s more\n' "$((total - MAX_HITS))"
  bump "$sev"
}

report() { # report <sev> <label> <hint> <pattern...>
  local sev="$1" label="$2" hint="$3"
  shift 3
  emit "$sev" "$label" "$hint" "$(gsearch "$@")"
}

strip_docs() {
  grep -v -E '^\./([Dd]ocs?|CHANGELOG|HISTORY|CHANGES|examples?|test|tests|spec|__tests__)/|\.(md|rst|adoc|txt|po|pot)(\.[a-z]+)?:[0-9]+:'
}

report_code() { # like report, but ignores documentation/changelog/test noise
  local sev="$1" label="$2" hint="$3"
  shift 3
  emit "$sev" "$label" "$hint" "$(gsearch "$@" | strip_docs)"
}

# ============================================================== CRITICAL ====
# Immediately exploitable if true: exposed credentials, secrets in the
# client bundle. Confirm each hit isn't a placeholder/example before reporting.
echo
echo "============================== CRITICAL ============================="

report CRIT "Hardcoded cloud/provider credentials" \
  "usable right now by anyone who reads the source or the built bundle" \
  'AKIA[0-9A-Z]{16}' \
  'sk-ant-[A-Za-z0-9_-]{20,}|sk-(live|test)-[A-Za-z0-9]{20,}|sk_(live|test)_[A-Za-z0-9]{20,}' \
  '(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}' \
  'xox[baprs]-[A-Za-z0-9-]{10,}' \
  'AIza[0-9A-Za-z_-]{30,}' \
  'eyJhbGciOiJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}' \
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'

report_code CRIT "Secret-shaped value assigned as a literal in source" \
  "a real key checked into source is exposed to anyone with repo access, and to the client if this file ships to the browser" \
  '(api[_-]?key|apikey|secret[_-]?key|client[_-]?secret|access[_-]?token|auth[_-]?token|private[_-]?key|db[_-]?password|service[_-]?role)[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_\-/+=]{16,}["'"'"']'

env_tracked="$(git -C "$APP_ABS" ls-files 2>/dev/null | grep -E '(^|/)\.env($|\.[a-z]+$)' | grep -v -E '\.env\.example$|\.env\.sample$|\.env\.template$')"
emit CRIT ".env file tracked by git" \
  "everything in it ships to every clone of the repo, including forks and CI logs" \
  "$env_tracked"

report CRIT "Secret-sounding value exposed to the client bundle" \
  "NEXT_PUBLIC_/VITE_/REACT_APP_/EXPO_PUBLIC_ prefixes ship the value straight into browser/app JS — fine for genuinely public keys, critical if it's a secret" \
  '(NEXT_PUBLIC_|VITE_|REACT_APP_|EXPO_PUBLIC_|PUBLIC_)[A-Z0-9_]*(SECRET|PRIVATE|SERVICE_ROLE|ADMIN|PASSWORD)[A-Z0-9_]*'

# ================================================================== HIGH ====
echo
echo "================================ HIGH ================================"

report_code HIGH "SQL/NoSQL query built by string concatenation or interpolation" \
  "user input reaching the query text directly is classic SQL/NoSQL injection" \
  '(SELECT|INSERT|UPDATE|DELETE|DROP)[^\n]{0,80}["'"'"']\s*\+\s*[A-Za-z_]' \
  '(execute|query|raw)\([[:space:]]*[fF]["'"'"']' \
  '(execute|query|raw)\([[:space:]]*`[^`]*\$\{' \
  '\$where["'"'"']?[[:space:]]*[:=]' \
  '\.raw\([[:space:]]*["'"'"'`][^)]*\$\{|\.raw\([[:space:]]*["'"'"'`][^)]*%s'

report HIGH "Command/code built from untrusted input" \
  "shell/eval/exec fed with anything that traces back to a request is remote code execution" \
  'os\.system\(|os\.popen\(|commands\.getoutput\(' \
  'subprocess\.(run|call|check_call|check_output|Popen)\([^)]*shell[[:space:]]*=[[:space:]]*True' \
  'child_process|execSync\(|spawnSync\(\s*[^,]*,\s*\[|exec\([[:space:]]*`[^`]*\$\{' \
  '(^|[^A-Za-z0-9_.$])eval[[:space:]]*\(' \
  'new[[:space:]]+Function[[:space:]]*\(' \
  '(^|[^A-Za-z0-9_.])exec[[:space:]]*\(|execfile[[:space:]]*\('

report_code HIGH "Unsanitized HTML/DOM sink" \
  "renders attacker-controlled content as live HTML/JS instead of text — stored/reflected XSS" \
  'dangerouslySetInnerHTML' \
  '\.innerHTML[[:space:]]*=[^=]' \
  'v-html[[:space:]]*=' \
  '\{!!\s*[^}]*!!\}' \
  'document\.write\(' \
  '\|[[:space:]]*safe\b'

report_code HIGH "TLS/certificate verification disabled" \
  "removes the only check that the connection isn't being intercepted — critical if it reaches production" \
  'verify[[:space:]]*=[[:space:]]*False|rejectUnauthorized[[:space:]]*:[[:space:]]*false' \
  'NODE_TLS_REJECT_UNAUTHORIZED|InsecureSkipVerify[[:space:]]*:[[:space:]]*true' \
  '(curl|wget)[^\n]*(--insecure|--no-check-certificate|[[:space:]]-k[[:space:]])' \
  'ServerTrustPolicy|allowsAnyHTTPSCertificateForHost'

report_code HIGH "Unsafe deserialization of untrusted data" \
  "loading untrusted pickles/YAML/serialized objects is remote code execution by design" \
  '(pickle|cPickle|marshal|dill)\.loads?\(' \
  'yaml\.load\((?!.*Loader=yaml\.SafeLoader)' \
  'ObjectInputStream|unserialize\('

# ================================================================ MEDIUM ====
echo
echo "=============================== MEDIUM ==============================="

report_code MED "CORS wildcard combined with credentials" \
  "any website can then read authenticated responses on the user's behalf" \
  'Access-Control-Allow-Origin["'"'"']?[[:space:]]*[:=][[:space:]]*["'"'"']\*' \
  'cors\(\{[^}]*origin[[:space:]]*:[[:space:]]*(true|["'"'"']\*)'

report_code MED "Debug/development mode left switchable in production paths" \
  "verbose errors and dev tooling leak internals to anyone who can trigger an error" \
  'DEBUG[[:space:]]*=[[:space:]]*True' \
  'app\.debug[[:space:]]*=[[:space:]]*[tT]rue' \
  'NODE_ENV[^\n]{0,20}!==?[[:space:]]*["'"'"']production' \
  'FLASK_DEBUG[[:space:]]*=[[:space:]]*1'

report_code MED "Weak hashing used for passwords/tokens" \
  "MD5/SHA1 are fast and unsalted by default — crackable at scale, not a password hash" \
  '(md5|sha1)\([^)]*(password|passwd|pwd|secret)' \
  'hashlib\.(md5|sha1)\('

report_code MED "Insecure randomness used for security-relevant values" \
  "Math.random()/rand() are predictable — fine for UI, not for tokens/passwords/IDs" \
  'Math\.random\(\)[^\n]{0,40}(token|password|secret|otp|reset|session)' \
  '(token|password|secret|otp|reset|session)[^\n]{0,40}Math\.random\(\)'

report_code MED "Open redirect from unvalidated input" \
  "lets an attacker turn your own domain into a phishing redirector" \
  'redirect\([[:space:]]*(req\.(query|params|body)|request\.(GET|POST|args))' \
  'window\.location(\.href)?[[:space:]]*=[[:space:]]*[^"'"'"'][A-Za-z_]'

report_code MED "Credentials or secrets referenced in local dotfiles read at runtime" \
  "often fine (dotenv), but confirm the values are never logged, sent to analytics, or bundled to the client" \
  '\.npmrc|\.pypirc|\.netrc' \
  '(readFile|open|load_dotenv)[^\n]{0,40}\.env([^a-zA-Z]|$)'

# =================================================================== LOW ====
echo
echo "================================= LOW ================================="

report_code LOW "Security-related TODO/FIXME left in code" \
  "a known, unresolved gap — worth a deliberate decision, not silence" \
  '(TODO|FIXME|XXX|HACK)[^\n]{0,80}(auth|security|sanitiz|escape|permission|inject|validat)'

env_example="$(find . -maxdepth 2 -iname '.env.example' -o -iname '.env.sample' -o -iname '.env.template' 2>/dev/null | sed 's|^\./||')"
[ -z "$env_example" ] && echo && echo "[LOW] No .env.example/.env.sample found — info only, harmless if the app has no secrets to document"

# ========================================================= MOBILE: iOS ======
is_ios=0
find . -name .git -prune -o \( -name '*.xcodeproj' -o -name '*.xcworkspace' -o -iname 'Info.plist' -o -name 'Podfile' -o -name 'Package.swift' \) -print -quit 2>/dev/null | grep -q . && is_ios=1

if [ "$is_ios" -eq 1 ]; then
  echo
  echo "============================= iOS-SPECIFIC ============================="

  report HIGH "App Transport Security disabled or weakened" \
    "allows the app to load plaintext HTTP or connections to untrusted hosts" \
    'NSAllowsArbitraryLoads[^\n]*(true|<true/>)' \
    'NSExceptionAllowsInsecureHTTPLoads[^\n]*(true|<true/>)'

  report_code MED "Secret written to UserDefaults or a plist instead of Keychain" \
    "UserDefaults/plist files are readable on a jailbroken device or from an unencrypted backup — Keychain is the only appropriate store for secrets on iOS" \
    'UserDefaults\.standard\.set\([^)]*(token|password|secret|key)' \
    '(setObject|setValue)\([^)]*forKey:[^)]*(token|password|secret|key)'

  report_code MED "WKWebView bridge exposed without an obvious origin check" \
    "a JS bridge callable from any loaded page can be triggered by malicious/compromised web content" \
    'addUserScript\(|evaluateJavaScript\(' \
    'WKUserContentController.*add\('
fi

# ===================================================== MOBILE: Android ======
is_android=0
find . -name .git -prune -o \( -iname 'AndroidManifest.xml' -o -name 'build.gradle' -o -name 'build.gradle.kts' \) -print -quit 2>/dev/null | grep -q . && is_android=1

if [ "$is_android" -eq 1 ]; then
  echo
  echo "=========================== ANDROID-SPECIFIC ==========================="

  report HIGH "Component exported without a visible permission check" \
    "an exported activity/service/receiver/provider is callable by any other app on the device" \
    'android:exported[[:space:]]*=[[:space:]]*["'"'"']true["'"'"']'

  report HIGH "Cleartext traffic permitted" \
    "lets the app fall back to plaintext HTTP, defeating TLS protections entirely" \
    'android:usesCleartextTraffic[[:space:]]*=[[:space:]]*["'"'"']true["'"'"']' \
    'cleartextTrafficPermitted[[:space:]]*=[[:space:]]*["'"'"']true["'"'"']'

  report_code HIGH "WebView JavaScript interface exposed" \
    "addJavascriptInterface bridges Java/Kotlin objects into any page the WebView loads — RCE if untrusted content ever reaches it" \
    'addJavascriptInterface\('

  report_code MED "Backup allowed without exclusion rules" \
    "android:allowBackup=true (the default) can let adb backup or cloud backup extract app data on older/rooted devices" \
    'android:allowBackup[[:space:]]*=[[:space:]]*["'"'"']true["'"'"']'
fi

# =============================================================== SUMMARY ====
echo
echo "============================== SUMMARY ================================"
printf '  CRITICAL %s | HIGH %s | MEDIUM %s | LOW %s\n' "$n_crit" "$n_high" "$n_med" "$n_low"
echo
echo "  These are LEADS, not conclusions. Open each flagged file and confirm it"
echo "  in context before reporting it as CONFIRMED. A clean scan is not proof"
echo "  of safety — it only means none of the known patterns matched, and this"
echo "  scanner does not check authentication/authorization logic, file-upload"
echo "  handling, or rate limiting at all (those need the workflow's manual"
echo "  review steps, not grep)."

if [ "$n_crit" -gt 0 ] || [ "$n_high" -gt 0 ]; then
  exit 20
elif [ "$n_med" -gt 0 ] || [ "$n_low" -gt 0 ]; then
  exit 10
fi
exit 0
