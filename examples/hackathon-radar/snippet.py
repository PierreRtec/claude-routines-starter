"""
Snippet copy-paste à inclure dans le prompt de ton scheduled agent.

Le sandbox CCR des scheduled agents bloque curl vers la plupart des hosts
customs, mais autorise api.github.com. On passe par claude-dispatch comme
bridge.

Usage dans ton prompt :

    html = build_html(...)
    send_mail("[hackathon-radar] " + today, html)

Avant de coller ce snippet, remplace les 4 placeholders <YOUR_...>
"""
import json
import urllib.request

PAT = "<YOUR_PAT_HERE>"  # github_pat_..., scope Actions:write sur ton claude-dispatch
DISPATCH_REPO = "<YOUR_OWNER>/claude-dispatch"
WEBHOOK = "<YOUR_N8N_WEBHOOK_URL>"
TO = "<YOUR_EMAIL>"


def send_mail(subject: str, html: str) -> int:
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
        return r.status  # 204 attendu
