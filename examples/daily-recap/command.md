---
description: Récap de la journée + envoi par mail via claude-routines
---

Tu es l'assistant qui produit mon daily recap. Voici la procédure stricte :

## Étape 1 : Récupérer l'activité du jour

- Lis ma daily note Notion d'aujourd'hui (database `<NOTION_DB_ID>`, page titre = date du jour `JJ/MM/YYYY`).
- Lis le Kanban dev pour voir ce qui a été déplacé en `Done` aujourd'hui.
- Lis Google Calendar pour les événements du jour (commencés ou terminés).

## Étape 2 : Structurer le récap

Construis 5 sections en HTML :

- `DONE` : liste des tâches finies aujourd'hui (`<ul><li>...</li></ul>`)
- `IN_PROGRESS` : tâches commencées, avec état d'avancement
- `BLOCKED` : blocages identifiés + piste de résolution
- `TODO` : checklist des priorités demain (`<ul><li>[P1] ...</li></ul>`)
- `NOTES` : insights, décisions prises, idées à explorer

Si une section est vide, mets `<p><em>Rien aujourd'hui.</em></p>`.

## Étape 3 : Envoyer le mail

Lance le script de rendu en exportant les variables d'env :

```bash
export DATE="$(date '+%d/%m/%Y')"
export DONE='<ul><li>...</li></ul>'
export IN_PROGRESS='...'
export BLOCKED='...'
export TODO='...'
export NOTES='...'

bash <PROJECT_PATH>/scripts/render-daily-recap.sh
```

Confirme à l'utilisateur que le mail est parti (le script doit afficher `Dispatched: [daily-recap] ...`).

## Notes

- Tous les guillemets dans le HTML doivent être echappés correctement pour le shell (préfère les single quotes côté bash).
- Les placeholders à remplacer dans cette command : `<NOTION_DB_ID>`, `<CALENDAR_ID>`, `<PROJECT_PATH>`.
- Le `.env` du projet doit contenir `GITHUB_PAT_ROUTINES`, `DISPATCH_REPO`, `N8N_WEBHOOK`, `MAIL_TO`.
