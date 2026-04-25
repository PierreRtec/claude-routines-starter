# claude-dispatch (bridge GitHub Actions)

Ce dossier n'est **PAS un sous-projet** du starter. C'est un template
pour un **autre repo** que tu vas créer.

## Pourquoi ?

Anthropic bloque l'egress de Claude (slash commands + scheduled agents)
vers la plupart des hosts customs. Seul `api.github.com` est whitelisté.

On contourne en passant par un repo GitHub qui sert de relais :
- Claude appelle l'API GitHub `/dispatches`.
- Un workflow GitHub Actions s'exécute dans ton repo.
- Il forward le payload vers ton webhook n8n.

```
Claude -> api.github.com (whitelisté)
       -> repository_dispatch event
       -> GitHub Actions runner
       -> ton webhook n8n (n'importe quel host)
       -> Gmail / Slack / Discord / ...
```

## Setup (5 minutes)

1. Crée un nouveau repo **privé** sur GitHub appelé `claude-dispatch`
   (ou autre nom si tu préfères).
2. Copie le fichier `.github/workflows/dispatch.yml` de ce dossier
   dans ton nouveau repo (mêmes chemins).
3. Commit et push. Le workflow s'active dès qu'il reçoit un
   `repository_dispatch` de type `forward`.

## Configurer le starter

Dans le `.env` de ton clone du starter, mets l'identifiant de ton bridge :

```bash
DISPATCH_REPO=<ton-username>/claude-dispatch
```

## Sécurité du PAT

Crée un PAT GitHub fine-grained :

- https://github.com/settings/personal-access-tokens/new
- Repository access : **Only select repositories** -> ton `claude-dispatch` uniquement
- Repository permissions : **Actions -> Read and write**
- Expiration : 90 jours (mets une alarme calendrier pour rotater)

Mets-le dans `.env` sous `GITHUB_PAT_ROUTINES`.

## Diagnostic

```bash
gh run list --repo <YOU>/claude-dispatch --limit 5
gh run view <run_id> --repo <YOU>/claude-dispatch --log
```

Cherche `Forwarding to:` et `---STATUS:` dans les logs.
- 204 / 200 -> OK
- 4xx -> probablement webhook n8n down ou auth Gmail expirée
- 5xx -> payload mal formé ou node n8n cassé
