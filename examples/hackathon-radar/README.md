# Example : `hackathon-radar` scheduled remote agent

Scheduled remote agent claude.ai qui scanne quotidiennement les hackathons IA pertinents et t'envoie un mail récap. Tourne tout seul tous les matins à 8h Paris.

## Pré-requis

- Compte claude.ai avec **scheduled remote agents** activés (feature payante côté Anthropic).
- Repo `claude-dispatch` créé et workflow `dispatch.yml` posé dedans (voir `claude-dispatch/README.md` du starter).
- PAT GitHub fine-grained avec scope **Actions:write sur ton repo claude-dispatch uniquement**.
- Webhook n8n mail-gateway opérationnel (voir le guide).

## Setup (10 min)

1. Sur claude.ai, créer un nouveau **scheduled remote agent**.
2. Nom : `hackathon-radar`. Cron : `0 6 * * *` (UTC, soit 8h Paris hors heure d'été).
3. Copier le contenu de `prompt.md` dans le prompt de l'agent.
4. Remplacer les **4 placeholders** dans le prompt :
   - `<YOUR_PAT_HERE>` -> ton PAT fine-grained
   - `<YOUR_DISPATCH_REPO>` -> `<owner>/claude-dispatch`
   - `<YOUR_N8N_WEBHOOK_URL>` -> URL du webhook copiée depuis n8n
   - `<YOUR_EMAIL>` -> ton adresse mail
5. Sauver.
6. Forcer un run immédiat (depuis l'UI claude.ai) pour valider.
7. Vérifier dans ta boîte mail + dans https://github.com/<YOU>/claude-dispatch/actions.

## Pourquoi ce pattern (Python urllib + claude-dispatch)

Le sandbox CCR des scheduled agents bloque `curl` vers la plupart des hosts customs. Seul `api.github.com` est whitelisté. Pas de `gh` CLI, pas de `jq` non plus.

D'où le pattern : Python urllib (toujours dispo, stdlib) + on POST sur l'API GitHub `/dispatches` qui déclenche un workflow Actions qui forward vers ton n8n.

## Sécurité du PAT

- Stocké inline dans le prompt sur les serveurs claude.ai.
- Risque limité par le scope ultra-restreint : **Actions:write sur 1 seul repo**.
- Si fuite : pas d'accès au reste de ton GitHub, seulement à déclencher des workflows sur le repo bridge.
- Bonne pratique : rotation tous les 90 jours (alarme calendrier).

## Adapter pour un autre cas d'usage

Le squelette reste le même :

1. Recherche / collecte de données dans le corps du prompt.
2. Construction d'un HTML lisible.
3. Appel à `send_mail(subject, html)` via le snippet Python.

Change juste le contenu de la recherche (tendances IA, résultats sportifs, météo, etc.) et le subject du mail.
