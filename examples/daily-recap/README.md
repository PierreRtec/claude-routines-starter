# Example : `/daily-recap` slash command

Slash command Claude Code locale qui résume ta journée et t'envoie le récap par mail.

## Setup (5 min)

1. Copie `command.md` dans le dossier `.claude/commands/` de ton projet :
   ```bash
   cp examples/daily-recap/command.md ~/<ton-projet>/.claude/commands/daily-recap.md
   ```
2. Adapte les placeholders `<NOTION_DB_ID>`, `<CALENDAR_ID>`, `<PROJECT_PATH>` dans `command.md` selon ton setup.
3. Copie `render.sh` dans le dossier `scripts/` de ton projet et rends-le exécutable :
   ```bash
   cp examples/daily-recap/render.sh ~/<ton-projet>/scripts/render-daily-recap.sh
   chmod +x ~/<ton-projet>/scripts/render-daily-recap.sh
   ```
4. Charge ton `.env` puis lance la slash command depuis Claude Code :
   ```
   /daily-recap
   ```

## Comment ça marche

1. Claude Code execute la slash command.
2. La commande récupère ton activité (Notion, Calendar) et construit un résumé structuré.
3. La dernière étape de la commande appelle `render.sh` qui remplit le template HTML.
4. `dispatch-mail.sh` envoie le HTML via claude-dispatch -> n8n -> Gmail.

## Personnalisation

- Pour changer le template HTML : édite `templates/daily-recap.html` du repo starter.
- Pour ajouter des sections (ex : pipeline, métriques) : modifie le template ET la commande pour passer les nouvelles variables d'env à `render.sh`.
- Pour changer la fréquence : ce pattern est on-demand. Pour un envoi quotidien automatique sans toi, regarde l'example `hackathon-radar` (scheduled remote agent).
