# claude-routines-starter

Reçois tes routines Claude Code (slash commands + scheduled agents) par mail
via n8n + claude-dispatch. Template clone-and-go.

> 📘 **Guide complet (vidéos + setup pas à pas) :** disponible sur
> [Gumroad](#) (lien à venir). Ce repo seul te donne le code, le guide
> t'apprend à l'orchestrer.

## Quickstart 5 minutes

1. Clique **« Use this template »** en haut de cette page → crée ton fork.
2. Clone ton fork en local.
3. Copie `.env.example` en `.env`, remplis les variables.
4. Importe `n8n-workflows/mail-gateway.json` dans ton n8n self-hosted.
5. Lance `bash scripts/test-webhook.sh` pour valider que le webhook + Gmail marchent.

Pour le pipeline complet (claude-dispatch bridge + slash command + scheduled
agent), suis le guide Gumroad.

## Architecture

```
Slash command / scheduled agent
  → scripts/dispatch-mail.sh
  → API GitHub repos/<dispatch_repo>/dispatches
  → workflow Actions claude-dispatch
  → POST n8n webhook
  → Gmail send (extensible Slack, Discord, SMS)
```

## Contenu du repo

| Dossier | Rôle |
|---|---|
| `scripts/` | `dispatch-mail.sh` (envoi mail) + `test-webhook.sh` |
| `templates/` | base + 2 variantes prêtes à utiliser |
| `examples/daily-recap/` | slash command locale qui résume ta journée |
| `examples/hackathon-radar/` | scheduled remote agent quotidien |
| `n8n-workflows/` | workflow `mail-gateway.json` à importer |
| `claude-dispatch/` | workflow GitHub Actions du bridge (à copier dans un autre repo) |

## Pré-requis

- **n8n self-hosted** : Railway, Heroku, Hostinger, ou n8n Cloud.
- **Compte GitHub** pour le repo bridge.
- **Compte Gmail** pour l'OAuth2 dans n8n.
- **Claude Code** installé pour les slash commands locales.
- (optionnel) Compte **claude.ai avec scheduled agents** pour les routines automatiques.

## Support

Pas de support 1-1 inclus. Ouvre une **Discussion** sur ce repo, je
réponds en moins de 48h.

## Affiliation

Ce projet est testé sur [Railway](https://railway.app/?referralCode=PIERRE)
(lien affilié). Le guide explique comment monter n8n dessus en 10 min.

## Licence

MIT, fais-en ce que tu veux.
