# Zeiterfassung

Zeitkonto-App: Start/Stop-Zeiterfassung mit Kategorien. Einzelne `index.html`
(Vanilla HTML/CSS/JS, kein Build-Schritt), im selben minimalistischen Stil wie
`guitar-song-coach` (Griffwerk).

## Architektur

- Alle Sessions liegen im Browser (localStorage) und werden zusätzlich per
  Google Apps Script Cloud-Sync ins Google Sheet "Arbeitszeiten" gespiegelt.
- `renderStats()` berechnet die Statistiken-Sektion (Gesamtzeit, Streak,
  Verteilung nach Wochentag/Kategorie) direkt aus den lokalen Sessions.
- `stopActive()` hat eine Absicherung gegen eine rückwärts springende
  Geräteuhr (`end = max(end, active.start)`), nachdem das früher zu negativen
  Session-Dauern im Sync geführt hat.
- `escapeHtml()` konsequent nutzen, wo Nutzer-/Kategorienamen per `innerHTML`
  gerendert werden (frühere XSS-Lücke, siehe Git-Historie).

## Workflow in diesem Repo

- Feature-Branch von `main` abzweigen, committen, pushen, Draft-PR öffnen,
  bei grüner CI ohne Blocker eigenständig aus dem Draft holen und mergen
  (squash), dann `unsubscribe_pr_activity`.
- Kein separates Test-Setup — Änderungen mit Playwright (headless Chromium,
  `executablePath: '/opt/pw-browsers/chromium'`) gegen `index.html` smoke-testen.

## Hindsight (Langzeitgedächtnis)

- `.claude/settings.json` (Hooks) und `.mcp.json` binden Hindsight Cloud über
  `.claude/hooks/hindsight.sh` ein (Paket `@vectorize-io/hindsight-coding-agents`,
  gepinnt auf 0.8.0, wird pro Container in `~/.cache` installiert).
- Aktiv nur, wenn `HINDSIGHT_API_TOKEN` in der Umgebung gesetzt ist; sonst
  tun die Hooks nichts. Memory-Bank: `coding-agent::Zeiterfassung`.
- Mit Token gehen Prompts und Sitzungsverläufe an Vectorize (Hindsight Cloud).

## Zusammenspiel mit claude.ai-Projects (Chat/Cowork)

Dieses Repo ist im claude.ai-Project "Kleine Anwendungen" als Kontext verknüpft.
Das Project liest dadurch automatisch den aktuellen Repo-Stand (Commits, Dateien,
auch diese Datei) — es gibt aber keinen Weg zurück: was im Project-Chat besprochen
wird, landet nicht automatisch hier.

Deshalb: tatsächliche Arbeitsanweisungen ("bau X", "ändere Y") nur hier im
Code-Bereich geben, nicht parallel im Project-Chat, damit nicht zwei Stellen
unabhängig voneinander am selben Code arbeiten. Wurde im Project-Chat trotzdem
etwas entschieden, das den Code betreffen soll, wird es zuerst hier (in dieser
Datei oder direkt in der nächsten Anweisung) festgehalten, bevor daran
gearbeitet wird.

## Namen der beteiligten KIs

Damit nichts verwechselt wird, hat jede KI, die an diesem Repo mitarbeitet,
einen eigenen festen Namen. Der Name hängt daran, *wo* die KI läuft — so weiß
jede Instanz beim Lesen dieser Datei, wie sie heißt.

| Name | Wer / wo |
|------|----------|
| **Zeno** | Claude Code im Code-Bereich (Sessions auf diesem Repo, lokal oder in der Cloud) |
| **Pia**  | claude.ai-Project "Kleine Anwendungen" (Project-Chat) |
| **Cora** | Claude Cowork |

Regeln:

- Jede KI kennt ihren Namen, nennt sich selbst so und wird von Luiz nur mit
  diesem Namen angesprochen.
- Eine KI reagiert nur auf Nachrichten, die an ihren eigenen Namen gehen.
  Ist eine Nachricht an einen anderen Namen adressiert (z. B. "Pia, …" in
  einer Zeno-Session), führt sie nichts davon aus, sondern antwortet nur kurz,
  dass die Nachricht an jemand anderen gerichtet ist. Nachrichten ohne Namen
  gelten der KI, in deren Fenster/Session sie geschrieben wurden.
- Kommt eine neue KI hinzu (weiterer Chat, zusätzliche parallele Session,
  Subagent, anderes Tool), bekommt sie einen neuen, noch nicht vergebenen
  Namen. Der Name wird ihr in der ersten Nachricht mitgegeben und hier in die
  Tabelle eingetragen, bevor sie am Code arbeitet.
