#!/usr/bin/env bash
# Test direct du webhook n8n sans passer par claude-dispatch.
# Utile pour vérifier que n8n + Gmail fonctionnent avant de débugger le bridge.
# Usage: test-webhook.sh
#
# Prérequis: variables d'env N8N_WEBHOOK, MAIL_TO (voir .env.example)

set -euo pipefail

: "${N8N_WEBHOOK:?Variable manquante: N8N_WEBHOOK}"
: "${MAIL_TO:?Variable manquante: MAIL_TO}"

curl -fsS -X POST \
  -H "Content-Type: application/json" \
  -d "{
    \"to\": \"${MAIL_TO}\",
    \"subject\": \"[test] webhook n8n direct\",
    \"html\": \"<h1>Hello</h1><p>Si tu reçois ce mail, le webhook + Gmail OAuth marchent.</p>\"
  }" \
  "${N8N_WEBHOOK}"

echo ""
echo "Webhook appelé. Vérifie ta boîte mail."
