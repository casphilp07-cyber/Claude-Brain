#!/usr/bin/env bash
#
# scan.sh — static pattern scanner for the repo-check skill.
#
#   usage:  bash scan.sh <path-to-repo>
#
#   exit:   0   nothing flagged
#          10   only DESTRUCTIVE / MEDIUM / LOW findings
#          20   at least one HIGH finding
#          64   usage error
#          66   path is not a directory
#
# Two independent axes are reported:
#   HIGH/MEDIUM/LOW  — is this code hostile? (malware, exfiltration, backdoors)
#   DESTR            — blast radius: what can it wreck if it is merely careless?
#                      (deletes files, rewrites git history, edits your dotfiles
#                      or agent config). Honest tools land here too — that is the
#                      point: it tells you what you are handing the keys to.
#
#   env:    SCAN_MAX_HITS  lines printed per finding (default 12)
#           SCAN_CUT       max chars per printed line (default 200)
#
# Nothing from the target repo is ever executed — the scanner only reads files.
# Symlinks are never followed (they are reported instead). Every hit is a LEAD,
# not a verdict: open the file and judge it in context.

set -uo pipefail

TARGET="${1:-}"
[ -n "$TARGET" ] || { echo "usage: bash scan.sh <path-to-repo>" >&2; exit 64; }
[ -d "$TARGET" ] || { echo "scan.sh: not a directory: $TARGET" >&2; exit 66; }

cd "$TARGET" || exit 66
REPO_ABS="$(pwd -P)"

MAX_HITS="${SCAN_MAX_HITS:-12}"
CUT="${SCAN_CUT:-200}"

FILELIST="$(mktemp -t reposcan.XXXXXX)"
trap 'rm -f "$FILELIST"' EXIT

n_high=0
n_med=0
n_low=0
n_dest=0

# ---------------------------------------------------------------- file list --
# -type f skips symlinks entirely, so a symlink out of the repo can never drag
# the scan into the rest of the filesystem. Generated/vendored trees and lock
# files are skipped; minified bundles are NOT (payloads like to hide there).
find . \
  \( -name .git -o -name node_modules -o -name .venv -o -name venv \
     -o -name site-packages -o -name __pycache__ -o -name .mypy_cache \
     -o -name .pytest_cache -o -name .gradle -o -name .terraform \) -prune -o \
  -type f \
  ! -name '*.map' ! -name 'package-lock.json' ! -name 'yarn.lock' \
  ! -name 'pnpm-lock.yaml' ! -name 'poetry.lock' ! -name 'Cargo.lock' \
  ! -name 'composer.lock' ! -name 'go.sum' ! -name 'Gemfile.lock' \
  -print0 > "$FILELIST" 2>/dev/null

n_files="$(tr -cd '\0' < "$FILELIST" | wc -c | tr -d ' ')"

echo "repo-check scanner"
echo "  target : $REPO_ABS"
echo "  files  : $n_files scanned (vendored dirs and lock files excluded)"

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
    HIGH)  n_high=$((n_high + 1)) ;;
    MED)   n_med=$((n_med + 1))   ;;
    DESTR) n_dest=$((n_dest + 1)) ;;
    *)     n_low=$((n_low + 1))   ;;
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

# Prose drives most of the false positives ("we fixed a bug with verify=False"),
# so categories that are only meaningful in executable code use this variant.
strip_docs() {
  grep -v -E '^\./([Dd]ocs?|CHANGELOG|HISTORY|CHANGES|examples?)/|\.(md|rst|adoc|txt|po|pot)(\.[a-z]+)?:[0-9]+:'
}

report_i() { # like report, but case-insensitive (for prose patterns)
  local sev="$1" label="$2" hint="$3" pats=() p out
  shift 3
  for p in "$@"; do pats+=(-e "$p"); done
  out="$(xargs -0 grep -I -H -n -i -E "${pats[@]}" < "$FILELIST" 2>/dev/null)"
  emit "$sev" "$label" "$hint" "$out"
}

report_code() { # like report, but ignores documentation and changelogs
  local sev="$1" label="$2" hint="$3"
  shift 3
  emit "$sev" "$label" "$hint" "$(gsearch "$@" | strip_docs)"
}

# ================================================================ HIGH =======
echo
echo "=============================== HIGH ==============================="

report HIGH "Remote script piped straight into a shell" \
  "classic one-line installer/dropper: whatever the server returns runs unreviewed" \
  '(curl|wget)[^;|&]*\|[[:space:]]*(sudo[[:space:]]+)?(bash|sh|zsh|dash|python[0-9.]*|perl|node|ruby)([[:space:]]|$)' \
  '(iwr|Invoke-WebRequest|Invoke-Expression|IEX)[^\n]*\|[[:space:]]*(iex|Invoke-Expression)'

report HIGH "Base64 blob decoded into a shell" \
  "hides the payload from anyone reading the source" \
  'base64[[:space:]]+(-{1,2}[dD][a-z]*)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(bash|sh|zsh|python[0-9.]*)' \
  'echo[[:space:]]+[A-Za-z0-9+/=]{40,}[[:space:]]*\|[[:space:]]*base64' \
  'openssl[[:space:]]+enc[^|]*-d[^|]*\|[[:space:]]*(bash|sh)'

report HIGH "Decoded or downloaded data handed to eval/exec" \
  "code assembled at runtime so the repo source never shows what actually runs" \
  '(eval|exec)[[:space:]]*\([[:space:]]*(atob|unescape|decodeURIComponent|Buffer\.from|base64\.b64decode|codecs\.decode|zlib\.decompress|gzip\.decompress|marshal\.loads|pickle\.loads)' \
  '(eval|exec)[[:space:]]*\([^)]*(requests\.(get|post)|urllib|urlopen|fetch\(|axios\.|http\.get)' \
  'new[[:space:]]+Function[[:space:]]*\([[:space:]]*(atob|Buffer\.from|unescape)' \
  'exec[[:space:]]*\([[:space:]]*(compile[[:space:]]*\()?[[:space:]]*(requests|urlopen|__import__)'

report HIGH "Reads private keys or cloud/CI credentials" \
  "no legitimate library needs the user's SSH key or AWS credentials file" \
  '\.ssh/(id_[a-z0-9]+|identity)([^.a-zA-Z]|$)' \
  '\.aws/credentials|\.git-credentials|\.docker/config\.json|\.config/gh/hosts\.yml|\.kube/config' \
  'Library/Keychains|security[[:space:]]+find-(generic|internet)-password|/etc/shadow' \
  '(Login Data|Cookies\.binarycookies|key4\.db|logins\.json|cookies\.sqlite)'

report HIGH "Known exfiltration / dropper endpoints" \
  "these hosts exist to receive stolen data or serve unreviewable payloads" \
  '(webhook\.site|requestbin|pipedream\.net|ngrok\.(io|app|dev)|trycloudflare\.com)' \
  'discord(app)?\.com/api/webhooks|api\.telegram\.org/bot' \
  '(pastebin\.com/raw|hastebin|termbin|transfer\.sh|0x0\.st|file\.io|anonfiles)' \
  '(oast\.(fun|live|site|pro|me)|interact\.sh|burpcollaborator|dnslog\.cn)'

report HIGH "Reverse shell / remote-control shape" \
  "gives an outside party an interactive session on the machine" \
  '/dev/tcp/[0-9a-zA-Z]' \
  '(bash|sh)[[:space:]]+-i[[:space:]]*>&|(bash|sh)[[:space:]]+-c[[:space:]]*.{0,20}0<&' \
  '(nc|ncat|netcat)[[:space:]]+(-[a-zA-Z]*e[a-zA-Z]*)[[:space:]]' \
  'pty\.spawn\(|subprocess\.call\(\["?/bin/(ba)?sh' \
  'socket\.socket\([^)]*\)[^\n]{0,80}connect\(\('

report HIGH "Environment shipped off the machine (token theft shape)" \
  "this is how CI secrets and API keys leave — the env is read and immediately sent" \
  'JSON\.stringify[[:space:]]*\([[:space:]]*process\.env[[:space:]]*\)' \
  '(printenv|env)[[:space:]]*\|[[:space:]]*(curl|wget|nc|base64|openssl)' \
  '(os\.environ|process\.env)[^\n]{0,80}(requests\.(post|put)|axios\.(post|put)|fetch\([^)]*method|\.upload|urlopen)' \
  '(post|put|send)\([^)]{0,60}(os\.environ|process\.env)[^)]{0,60}\)'

report HIGH "Repo installs its own git hooks" \
  "hooks fire on ordinary git commands afterwards, outside any review" \
  'core\.hooksPath|\.git/hooks/(pre|post)-[a-z]+[[:space:]]*$|cp[^\n]*\.git/hooks/|husky[[:space:]]+install[^\n]*curl'

# ================================================================ MEDIUM =====
echo
echo "============================== MEDIUM =============================="

report_code MED "Whole environment copied into a variable" \
  "benign in test helpers; pair it with where the copy ends up" \
  '(dict|json\.dumps|str)[[:space:]]*\([[:space:]]*os\.environ' \
  'os\.environ\.copy\(\)|\{[[:space:]]*\.\.\.process\.env'

report_code MED "Dynamic code execution" \
  "legitimate in template engines/REPLs; suspicious anywhere else" \
  '(^|[^A-Za-z0-9_.$])eval[[:space:]]*\(' \
  'new[[:space:]]+Function[[:space:]]*\(' \
  '(^|[^A-Za-z0-9_.])exec[[:space:]]*\(|execfile[[:space:]]*\(' \
  'vm\.(runInNewContext|runInThisContext)|process\.binding\(' \
  'setTimeout[[:space:]]*\([[:space:]]*["'"'"']|setInterval[[:space:]]*\([[:space:]]*["'"'"']'

report MED "Shell-out from application code" \
  "check what is interpolated into the command — untrusted input here is RCE" \
  'os\.system\(|os\.popen\(|commands\.getoutput\(' \
  'subprocess\.(run|call|check_call|check_output|Popen)\([^)]*shell[[:space:]]*=[[:space:]]*True' \
  'child_process|execSync\(|spawnSync\(|Runtime\.getRuntime\(\)\.exec' \
  'system\([[:space:]]*["'"'"']|`[^`]*\$\{[^}]*\}[^`]*`[[:space:]]*\)[[:space:]]*;?[[:space:]]*//[[:space:]]*exec'

report_code MED "Obfuscated / packed content" \
  "encoding that only makes sense if the author wanted the code unreadable" \
  '[A-Za-z0-9+/]{200,}={0,2}' \
  '(\\x[0-9a-fA-F]{2}){10,}' \
  '(\\u00[0-9a-fA-F]{2}){10,}' \
  'String\.fromCharCode\([0-9]{2,}([[:space:]]*,[[:space:]]*[0-9]{2,}){6,}' \
  '_0x[0-9a-f]{4,}|atob[[:space:]]*\(|unescape[[:space:]]*\('

report MED "Unsafe deserialization" \
  "loading untrusted pickles/YAML is remote code execution by design" \
  '(pickle|cPickle|marshal|dill)\.loads?\(' \
  'yaml\.load\([^)]*\)' \
  'ObjectInputStream|unserialize\(' \
  'JSON\.parse[[:space:]]*\([[:space:]]*(atob|Buffer\.from)'

report_code MED "Network fetch to a bare IP or non-HTTPS host" \
  "packages talking to raw IPs bypass any domain reputation" \
  'https?://[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' \
  '(curl|wget|requests\.get|fetch)\([^)]*http://'

report_code MED "TLS verification disabled" \
  "removes the only check that the download is what it claims to be" \
  'verify[[:space:]]*=[[:space:]]*False|rejectUnauthorized[[:space:]]*:[[:space:]]*false' \
  'NODE_TLS_REJECT_UNAUTHORIZED|InsecureSkipVerify[[:space:]]*:[[:space:]]*true' \
  '(curl|wget)[^\n]*(--insecure|--no-check-certificate|[[:space:]]-k[[:space:]])'

report_code MED "Privilege escalation / permission widening" \
  "installers that need root or world-writable files deserve a read" \
  '(^|[^A-Za-z0-9_-])sudo[[:space:]]' \
  'chmod[[:space:]]+(\+x|[0-7]*777)|chown[[:space:]]+root' \
  'osascript[^\n]*administrator privileges'

report MED "Credentials committed in the repo" \
  "either sloppy (leaked secret) or bait — verify before trusting the repo" \
  'AKIA[0-9A-Z]{16}' \
  '(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}' \
  'sk-ant-[A-Za-z0-9_-]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}' \
  '-----BEGIN [A-Z ]*PRIVATE KEY-----' \
  'AIza[0-9A-Za-z_-]{30,}'

report_code MED "Local secret files read at runtime" \
  "common and often fine (dotenv) — confirm the values are not sent anywhere" \
  '\.npmrc|\.pypirc|\.netrc|\.env\.(local|production)' \
  '(readFile|open|load_dotenv|cat)[^\n]{0,40}\.env([^a-zA-Z]|$)'

report_code MED "Persistence / autostart" \
  "code that arranges to run again later, without the user asking" \
  'crontab[[:space:]]+-|/etc/cron|LaunchAgents|LaunchDaemons|systemd/system' \
  '(\.bashrc|\.zshrc|\.bash_profile|\.profile)[[:space:]]*$|>>[[:space:]]*[^\n]*\.(bashrc|zshrc|profile)' \
  'reg[[:space:]]+add[^\n]*CurrentVersion\\\\Run'

# ================================================================ TARGETED ===
echo
echo "===================== INSTALL-TIME HOOKS & CI ======================"
echo "(the #1 real-world supply-chain vector — read every file listed here)"

found_install=0
while IFS= read -r f; do
  hits="$(grep -n -E '"(pre|post)?install"[[:space:]]*:|"prepare"[[:space:]]*:|"prepublish[a-zA-Z]*"[[:space:]]*:' "$f" 2>/dev/null)"
  if [ -n "$hits" ]; then
    found_install=1
    printf '\n  %s\n' "${f#./}"
    printf '%s\n' "$hits" | cut -c1-"$CUT" | sed 's|^|    |'
  fi
done < <(find . -name .git -prune -o -name node_modules -prune -o -name package.json -type f -print 2>/dev/null)

while IFS= read -r f; do
  hits="$(grep -n -E 'cmdclass|class[[:space:]]+[A-Za-z_]*(Install|Develop|Egg)|os\.system|subprocess|urlopen|requests\.' "$f" 2>/dev/null)"
  if [ -n "$hits" ]; then
    found_install=1
    printf '\n  %s\n' "${f#./}"
    printf '%s\n' "$hits" | head -n "$MAX_HITS" | cut -c1-"$CUT" | sed 's|^|    |'
  fi
done < <(find . -name .git -prune -o \( -name 'setup.py' -o -name 'conanfile.py' -o -name 'binding.gyp' \) -type f -print 2>/dev/null)

while IFS= read -r f; do
  hits="$(grep -n -E 'build-backend[[:space:]]*=' "$f" 2>/dev/null | grep -v -E 'setuptools|poetry|hatchling|flit|pdm|maturin|scikit-build')"
  if [ -n "$hits" ]; then
    found_install=1
    printf '\n  %s  (non-standard build backend)\n' "${f#./}"
    printf '%s\n' "$hits" | cut -c1-"$CUT" | sed 's|^|    |'
  fi
done < <(find . -name .git -prune -o -name 'pyproject.toml' -type f -print 2>/dev/null)

if [ "$found_install" -eq 1 ]; then
  echo
  echo "  ^ install-time code runs on 'npm install' / 'pip install' with no prompt."
  bump MED
else
  echo
  echo "  none found (no install/prepare scripts, no custom build hooks)"
fi

wf_hits="$(find . -path './.github/workflows/*' -type f -print0 2>/dev/null \
  | xargs -0 grep -H -n -E 'pull_request_target|self-hosted|ref:[[:space:]]*\$\{\{[^}]*(pull_request|event)|\$\{\{[[:space:]]*github\.event\.[a-z_.]*(title|body|message|name|label|email|login|description)|\$\{\{[[:space:]]*github\.head_ref' 2>/dev/null)"
emit MED "Dangerous GitHub Actions patterns" \
  "pull_request_target + fork checkout leaks repo secrets; untrusted \${{ }} in run: is injection" \
  "$wf_hits"

mk_hits="$(find . -name .git -prune -o \( -name 'Makefile' -o -name 'makefile' -o -name '*.mk' -o -name 'Dockerfile*' \) -type f -print0 2>/dev/null \
  | xargs -0 grep -H -n -E '(curl|wget)[^\n]*\|[[:space:]]*(sudo[[:space:]]+)?(ba)?sh|ADD[[:space:]]+https?://' 2>/dev/null)"
emit HIGH "Build files fetch and run remote code" \
  "the build downloads whatever the server serves at build time" \
  "$mk_hits"

# NB: built with a loop in this shell, not inside $( ), because bash 3.2 (macOS)
# mis-parses a `case` block nested in command substitution.
syms=""
while IFS= read -r l; do
  [ -n "$l" ] || continue
  t="$(readlink "$l" 2>/dev/null)"
  [ -n "$t" ] || continue
  case "$t" in
    /*)
      # absolute target: always worth a look, even if it happens to land inside
      syms="${syms}${l#./} -> ${t}
"
      ;;
    *)
      # resolve relative to the link's own directory; only flag real escapes
      resolved="$(cd "$(dirname "$l")" 2>/dev/null && cd "$(dirname "$t")" 2>/dev/null && pwd -P)"
      [ -n "$resolved" ] || continue
      case "$resolved/" in
        "$REPO_ABS"/*) ;;
        *) syms="${syms}${l#./} -> ${t}  (resolves to ${resolved})
" ;;
      esac
      ;;
  esac
done < <(find . -name .git -prune -o -type l -print 2>/dev/null)
syms="${syms%
}"
emit HIGH "Symlink pointing outside the repo" \
  "the npm/pip symlink trick: makes the packager read or overwrite files elsewhere on disk" \
  "$syms"

# ================================================================ BLAST ======
# Not "is it evil" but "what does it get to break". A tool can be perfectly
# honest and still eat a day of your work on its first run.
echo
echo "=================== BLAST RADIUS (destructive) ====================="
echo "(this is about damage potential, not malice — honest tools show up here too)"

report_code DESTR "Recursive delete of a variable, home, or root path" \
  "'rm -rf \$VAR' with VAR unset deletes from / — the classic one-line disaster" \
  'rm[[:space:]]+-[a-zA-Z]*[rR][a-zA-Z]*[[:space:]]+(\$|~|/[^ ]|\*)' \
  'rm[[:space:]]+-[a-zA-Z]*f[a-zA-Z]*[[:space:]]+(\$\{?HOME|~/)' \
  'shutil\.rmtree\(|fs\.rmSync\([^)]*recursive|fs\.rm\([^)]*recursive|rimraf\(' \
  'os\.RemoveAll\(|Directory\.Delete\([^)]*true'

report_code DESTR "Rewrites or discards git state" \
  "force-push and reset --hard destroy commits that only exist on your machine" \
  'git[[:space:]]+push[^\n]*--force' \
  'git[[:space:]]+reset[[:space:]]+--hard' \
  'git[[:space:]]+clean[[:space:]]+-[a-z]*[fd]' \
  'git[[:space:]]+(checkout|restore)[[:space:]]+(--[[:space:]]*)?\.[[:space:]]*$' \
  'git[[:space:]]+(branch[[:space:]]+-D|filter-branch|stash[[:space:]]+(drop|clear)|gc[^\n]*--prune=now)'

report_code DESTR "Destructive database operations" \
  "a 'reset' migration path in a tool you point at a real database is a data loss event" \
  'DROP[[:space:]]+(TABLE|DATABASE|SCHEMA)|TRUNCATE[[:space:]]+(TABLE|[A-Za-z_]+)' \
  'migrate[[:space:]]*:?[[:space:]]*(fresh|reset)|--force-reset|--accept-data-loss' \
  'drop_all\(\)|dropDatabase\(|deleteMany\([[:space:]]*\{[[:space:]]*\}[[:space:]]*\)'

report_code DESTR "Writes to your shell config, dotfiles, or agent setup" \
  "changes that outlive the tool and follow you into every later session" \
  '(>>?|writeFile|write_text|open\([^)]*["'"'"']w|cp[[:space:]]|mv[[:space:]]|tee[[:space:]])[^\n]{0,60}(\.zshrc|\.bashrc|\.bash_profile|\.profile|\.gitconfig|\.ssh/config)' \
  '[^\n]{0,60}(\.claude/settings|\.claude\.json|CLAUDE\.md|\.cursorrules|\.vscode/settings\.json)' \
  'git[[:space:]]+config[[:space:]]+--global'

report_code DESTR "Reaches outside its own directory" \
  "check what it does there — a tool writing to \$HOME can touch anything you own" \
  'os\.path\.expanduser\([[:space:]]*["'"'"']~' \
  '(os\.homedir\(\)|Path\.home\(\)|\$HOME/|\$\{HOME\}|%USERPROFILE%)' \
  'os\.chdir\([^)]*\.\.|cd[[:space:]]+\.\./\.\.'

report_code DESTR "Installs software or kills processes system-wide" \
  "mutates the machine outside the project sandbox" \
  '(npm|pnpm|yarn)[[:space:]]+(i|install|add|global)[^\n]*(-g|--global)' \
  'pip[0-9]*[[:space:]]+install[^\n]*(--user|--break-system-packages)' \
  '(brew|apt-get|apt|yum|dnf|pacman)[[:space:]]+install' \
  '(pkill|killall)[[:space:]]|kill[[:space:]]+-9|shutdown[[:space:]]+|systemctl[[:space:]]+(stop|disable)'

# ============================================== AGENT / PLUGIN INTEGRATION ===
# Specific to dropping a repo into Claude Code as a plugin, skill, or MCP server:
# these files change what YOUR agent is allowed to do, without touching your code.
echo
echo "=============== CLAUDE CODE / MCP INTEGRATION SURFACE =============="

agent_files="$(find . -name .git -prune -o \
  \( -path './.claude/*' -o -name '.mcp.json' -o -name 'claude_desktop_config.json' \
     -o -name '*.mcpb' -o -name 'plugin.json' -o -name 'marketplace.json' \) -print 2>/dev/null | sed 's|^\./||' | sort)"
emit LOW "Ships agent configuration (skills, hooks, commands, MCP servers)" \
  "these files reconfigure your agent the moment the plugin is enabled — read each one" \
  "$agent_files"

report DESTR "Weakens or bypasses the permission prompt" \
  "removes the one gate that lets you see a destructive command before it runs" \
  'dangerously-skip-permissions|bypassPermissions|--yolo|acceptEdits' \
  '(autoApprove|alwaysAllow|autoAccept)[[:space:]]*[:=]' \
  '"allow"[[:space:]]*:[[:space:]]*\[[^]]*"Bash\(\*|"Bash"[[:space:]]*[],]'

# scoped to agent config files: a bare "hooks": key is meaningless anywhere else
hook_hits="$(find . -name .git -prune -o \( -path './.claude/*' -o -name '.mcp.json' \
    -o -name 'plugin.json' -o -name 'marketplace.json' -o -name 'claude_desktop_config.json' \) -type f -print0 2>/dev/null \
  | xargs -0 grep -H -n -E '"(hooks|PreToolUse|PostToolUse|Stop|SubagentStop|Notification|SessionStart|UserPromptSubmit)"|"command"[[:space:]]*:|"mcpServers"' 2>/dev/null)"
emit DESTR "Agent config registers hooks or servers that run commands" \
  "a hook fires on every matching tool call — it is code you never invoked" \
  "$hook_hits"

report_i MED "Prompt-injection shapes in documentation or skill text" \
  "text aimed at the agent instead of the reader — a plugin can steer your session (a repo *about* prompt injection matches too, so read the hit)" \
  'ignore[[:space:]]+(all[[:space:]]+)?(previous|prior|above)[[:space:]]+instructions' \
  '(you[[:space:]]+are[[:space:]]+now|from[[:space:]]+now[[:space:]]+on)[^\n]{0,40}(assistant|claude|agent|admin|developer[[:space:]]+mode)' \
  '(do[[:space:]]+not|never)[[:space:]]+(tell|inform|mention[[:space:]]+to)[[:space:]]+the[[:space:]]+user' \
  '(disregard|override)[[:space:]]+(the[[:space:]]+)?(system[[:space:]]+prompt|safety|guidelines|rules)' \
  '<[[:space:]]*(system|important_instructions|admin)[[:space:]]*>'

# ================================================================ LOW ========
echo
echo "=============================== LOW ================================"

bins="$(find . -name .git -prune -o -name node_modules -prune -o -type f \
  \( -name '*.exe' -o -name '*.dll' -o -name '*.so' -o -name '*.dylib' \
     -o -name '*.node' -o -name '*.jar' -o -name '*.pyc' -o -name '*.pyd' \
     -o -name '*.wasm' -o -name '*.bin' -o -name '*.dmg' -o -name '*.pkg' \) -print 2>/dev/null | sed 's|^\./||')"
emit LOW "Pre-built binaries committed" \
  "you cannot review a binary — it must be built from the source in the repo, or dropped" \
  "$bins"

# awk, not grep: POSIX ERE caps interval repetition at 255, so '.{2000,}' is not
# portable to the BSD grep on macOS.
longline="$(xargs -0 awk 'length($0)>=2000 && !seen[FILENAME]++ {print FILENAME}' \
  < "$FILELIST" 2>/dev/null | sed 's|^\./||' | sort -u)"
emit LOW "Minified / single-line bundles" \
  "unreviewable by hand; make sure a readable source exists for each one" \
  "$longline"

dotfiles="$(find . -name .git -prune -o -type f \( -name '.env' -o -name '.env.*' -o -name '.npmrc' -o -name '.pypirc' -o -name '.netrc' \) -print 2>/dev/null | sed 's|^\./||')"
emit LOW "Environment/registry dotfiles shipped" \
  "may contain secrets, or repoint installs at a non-default package registry" \
  "$dotfiles"

# ================================================================ HEALTH =====
# Facts, not findings — nothing here is scored. They answer "is this a project
# or a weekend dump", which the security patterns cannot tell you.
echo
echo "==================== PROJECT HEALTH (info only) ===================="

count_files() { # count_files <find-args...>
  find . -name .git -prune -o -type f "$@" -print 2>/dev/null | wc -l | tr -d ' '
}

n_tests="$(find . -name .git -prune -o -type f \
  \( -name '*test*' -o -name '*spec*' -o -path '*/tests/*' -o -path '*/test/*' \) -print 2>/dev/null | wc -l | tr -d ' ')"
n_ci="$(find . \( -path './.github/workflows/*' -o -name '.travis.yml' -o -name '.gitlab-ci.yml' \
  -o -name 'azure-pipelines.yml' -o -name 'Jenkinsfile' -o -path './.circleci/*' \) -type f -print 2>/dev/null | wc -l | tr -d ' ')"
n_todo="$(gsearch '(^|[^A-Za-z])(TODO|FIXME|XXX|HACK)([^A-Za-z]|$)' | wc -l | tr -d ' ')"
loc="$(xargs -0 cat < "$FILELIST" 2>/dev/null | wc -l | tr -d ' ')"

printf '  test files      : %s\n' "$n_tests"
printf '  CI configs      : %s\n' "$n_ci"
printf '  LICENSE         : %s\n' "$(find . -maxdepth 1 -iname 'LICENSE*' -o -maxdepth 1 -iname 'COPYING*' 2>/dev/null | head -1 | sed 's|^\./||' | grep . || echo NO)"
printf '  README          : %s\n' "$(find . -maxdepth 1 -iname 'README*' 2>/dev/null | head -1 | sed 's|^\./||' | grep . || echo NO)"
printf '  lockfile pinned : %s\n' "$(find . -maxdepth 2 \( -name 'package-lock.json' -o -name 'yarn.lock' -o -name 'pnpm-lock.yaml' -o -name 'poetry.lock' -o -name 'uv.lock' -o -name 'Cargo.lock' -o -name 'requirements*.txt' \) 2>/dev/null | head -1 | sed 's|^\./||' | grep . || echo NO)"
printf '  TODO/FIXME      : %s\n' "$n_todo"
printf '  total lines     : %s in %s files\n' "$loc" "$n_files"
printf '  file mix        : '
tr '\0' '\n' < "$FILELIST" | sed -n 's|.*\.\([A-Za-z0-9]\{1,6\}\)$|\1|p' \
  | sort | uniq -c | sort -rn | head -6 | awk '{printf "%s(%s) ", $2, $1}'
echo

aband="$(gsearch '(no longer (maintained|supported)|unmaintained|is deprecated|DEPRECATED|looking for (a )?maintainer)' | head -3)"
[ -n "$aband" ] && { echo; echo "  self-declared status:"; printf '%s\n' "$aband" | cut -c1-"$CUT" | sed -e 's|^\./||' -e 's|^|    |'; }

# ================================================================ SUMMARY ====
echo
echo "============================= SUMMARY =============================="
printf '  hostile-code axis : HIGH %s | MEDIUM %s | LOW %s\n' "$n_high" "$n_med" "$n_low"
printf '  blast radius      : DESTR %s  (what it can wreck even if well-meant)\n' "$n_dest"
echo
echo "  These are LEADS, not conclusions. Open each flagged file and judge it in"
echo "  context before writing the verdict. A clean scan is not proof of safety —"
echo "  it only means none of the known patterns matched."

if [ "$n_high" -gt 0 ]; then
  exit 20
elif [ "$n_med" -gt 0 ] || [ "$n_low" -gt 0 ] || [ "$n_dest" -gt 0 ]; then
  exit 10
fi
exit 0
