#!/usr/bin/env bash
# Remplit le template daily-recap.html avec les variables d'env, puis dispatch.
#
# Variables d'env attendues (toutes obligatoires) :
#   DATE, DONE, IN_PROGRESS, BLOCKED, TODO, NOTES
#
# Prérequis : .env chargé avec GITHUB_PAT_ROUTINES, DISPATCH_REPO, N8N_WEBHOOK, MAIL_TO

set -euo pipefail

: "${DATE:?Variable manquante: DATE}"
: "${DONE:?Variable manquante: DONE}"
: "${IN_PROGRESS:?Variable manquante: IN_PROGRESS}"
: "${BLOCKED:?Variable manquante: BLOCKED}"
: "${TODO:?Variable manquante: TODO}"
: "${NOTES:?Variable manquante: NOTES}"

# Adapter ce chemin si tu déplaces le repo starter
STARTER_DIR="${STARTER_DIR:-$HOME/claude-routines-starter}"

TEMPLATE="${STARTER_DIR}/templates/daily-recap.html"
OUTPUT="/tmp/daily-recap.html"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template introuvable: $TEMPLATE" >&2
  echo "Définis STARTER_DIR vers ton clone de claude-routines-starter." >&2
  exit 1
fi

python <<PY > "$OUTPUT"
import os
with open("${TEMPLATE}", "r", encoding="utf-8") as f:
    html = f.read()
for key in ("DATE", "DONE", "IN_PROGRESS", "BLOCKED", "TODO", "NOTES"):
    html = html.replace("{{" + key + "}}", os.environ[key])
print(html)
PY

bash "${STARTER_DIR}/scripts/dispatch-mail.sh" "[daily-recap] $DATE" "$OUTPUT"
