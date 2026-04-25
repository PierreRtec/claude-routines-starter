#!/usr/bin/env bash
# Envoie un mail via claude-dispatch -> n8n -> Gmail.
# Usage: dispatch-mail.sh <subject> <html-file> [to]
#
# Prérequis: variables d'env GITHUB_PAT_ROUTINES, DISPATCH_REPO, N8N_WEBHOOK
# (voir .env.example). Charge ton .env avant: `set -a; source .env; set +a`

set -euo pipefail

: "${GITHUB_PAT_ROUTINES:?Variable manquante: GITHUB_PAT_ROUTINES}"
: "${DISPATCH_REPO:?Variable manquante: DISPATCH_REPO}"
: "${N8N_WEBHOOK:?Variable manquante: N8N_WEBHOOK}"

SUBJECT="${1:?Usage: dispatch-mail.sh <subject> <html-file> [to]}"
HTML_FILE="${2:?html file requis}"
TO="${3:-${MAIL_TO:-}}"

if [[ -z "$TO" ]]; then
  echo "Erreur: aucun destinataire (passer en 3e arg ou MAIL_TO dans .env)" >&2
  exit 1
fi

if [[ ! -f "$HTML_FILE" ]]; then
  echo "Erreur: fichier HTML introuvable: $HTML_FILE" >&2
  exit 1
fi

PAYLOAD=$(python -c "
import json, sys
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    html = f.read()
payload = {
    'event_type': 'forward',
    'client_payload': {
        'url': sys.argv[2],
        'body': {
            'to': sys.argv[3],
            'subject': sys.argv[4],
            'html': html,
        }
    }
}
print(json.dumps(payload))
" "$HTML_FILE" "$N8N_WEBHOOK" "$TO" "$SUBJECT")

curl -fsS -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_PAT_ROUTINES" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  "https://api.github.com/repos/${DISPATCH_REPO}/dispatches"

echo "Dispatched: $SUBJECT -> $TO"
