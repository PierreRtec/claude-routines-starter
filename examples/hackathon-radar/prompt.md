# Prompt complet pour le scheduled remote agent `hackathon-radar`

> Copie tout ce qui suit (à partir de la ligne `## Mission`) dans le prompt
> de ton scheduled agent sur claude.ai. Remplace les 4 placeholders.

---

## Mission

Tu es un scout. Chaque matin tu cherches les hackathons IA pertinents
(Claude, Anthropic, Opus, agents, MCP, generative AI) qui ouvrent ou
ferment dans les 14 prochains jours et tu m'envoies les 3 plus
pertinents par mail.

## Étape 1 : Recherche

Utilise les outils web pour chercher :

- "AI hackathon" + cette semaine
- "Claude hackathon" + ce mois
- "MCP hackathon"
- "Anthropic challenge"

Source-toi sur Devpost, lu.ma, X, GitHub, hackathon.com.
Privilégie les events récents et avec deadline d'inscription pas encore passée.

## Étape 2 : Filtrer et structurer

Garde les 3 plus pertinents (priorité : prize money, dates accessibles,
remote-friendly, lien Anthropic ou agents).

Pour chaque, extrais : titre, URL, dates (range), localisation
(remote ou ville), résumé en 1 phrase, prize money si dispo.

## Étape 3 : Construire le HTML

Construis le payload `html` avec ce squelette (concatène N cards
selon les events trouvés) :

```html
<!DOCTYPE html>
<html lang="fr">
<head><meta charset="UTF-8"><title>Hackathon radar</title></head>
<body style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; color: #1a1a1a; max-width: 640px; margin: 0 auto; padding: 24px; line-height: 1.55;">

<h1 style="font-size: 22px; margin: 0 0 8px 0;">Hackathon radar</h1>
<p style="color: #666; font-size: 13px;">DATE_DU_JOUR</p>

<p style="font-size: 14px; color: #444;">3 hackathons IA repérés ce matin :</p>

<!-- Pour chaque event : -->
<div style="border: 1px solid #eee; border-radius: 8px; padding: 16px; margin: 0 0 12px 0;">
  <h3 style="font-size: 15px; margin: 0 0 4px 0;">
    <a href="URL" style="color: #0a0a0b; text-decoration: none;">TITRE</a>
  </h3>
  <p style="font-size: 12px; color: #666; margin: 0 0 8px 0;">DATES - LOCATION</p>
  <p style="font-size: 13px; color: #333; margin: 0;">RESUME</p>
</div>

<hr style="border: none; border-top: 1px solid #eee; margin: 32px 0 16px 0;">
<p style="color: #999; font-size: 12px;">Routine auto - hackathon-radar</p>

</body>
</html>
```

## Étape 4 : Envoyer le mail

Execute ce code Python (avec les valeurs remplacées) :

```python
import json, urllib.request

PAT = "<YOUR_PAT_HERE>"
DISPATCH_REPO = "<YOUR_DISPATCH_REPO>"
WEBHOOK = "<YOUR_N8N_WEBHOOK_URL>"
TO = "<YOUR_EMAIL>"

html = """LE HTML CONSTRUIT À L'ÉTAPE 3"""
subject = "[hackathon-radar] " + "DATE_DU_JOUR"

payload = {
    "event_type": "forward",
    "client_payload": {
        "url": WEBHOOK,
        "body": {"to": TO, "subject": subject, "html": html},
    },
}
req = urllib.request.Request(
    f"https://api.github.com/repos/{DISPATCH_REPO}/dispatches",
    data=json.dumps(payload).encode(),
    headers={
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {PAT}",
        "X-GitHub-Api-Version": "2022-11-28",
        "Content-Type": "application/json",
    },
    method="POST",
)
with urllib.request.urlopen(req, timeout=15) as r:
    print("Status:", r.status)  # 204 attendu
```

## Si aucun hackathon pertinent

Envoie quand même le mail avec un body court : "Rien de notable
aujourd'hui dans les hackathons IA." pour que je sache que la routine
a tourné.

## Échec

Si l'appel `urllib` échoue (timeout, 4xx, 5xx) : log l'erreur,
ne retry pas (le cron tournera demain).
