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

## Gedächtnis: nur lokal

- Kein Hindsight Cloud (Vectorize) und keine anderen Cloud-Gedächtnisdienste
  in diesem Repo: keine Hooks, kein `.mcp.json`, die Prompts oder Verläufe an
  externe Dienste schicken. Entscheidung von Luiz (2026-10-08); die frühere
  Anbindung (#8) wurde wieder entfernt.
- Langzeitgedächtnis läuft ausschließlich über Luiz' eigenen Server auf
  seinem PC (Connector „Luiz Memory“ in claude.ai).

## Offene Probleme: immer ins Gedächtnis (Regel von Luiz, 2026-10-08)

Gilt für alle KIs (Pia-Kobalt, Pia-Opal, Pia-Quarz und alle künftigen):

- Besteht ein Problem oder eine unerledigte Aufgabe, wird sie **sofort** als
  eigenes Dokument in Bank `luiz` gespeichert (Luiz Memory), nicht erst am
  Sitzungsende. Was nur im Chat, in einer Session oder einer temporären
  Datei steht, gilt als nicht gesichert.
- Das Dokument ist eigenständig verständlich, damit jede andere KI direkt von
  dort weiterarbeiten kann. Es enthält: Ziel, Stand, Diagnose, Checkliste,
  nötige Befehle/Prompts, Grenzen, Belege und wer zuletzt daran gearbeitet hat.
- Es bekommt eine feste `document_id` nach dem Schema `problem-<thema>` und das Tag
  `problem:open`. Fortschritt wird im selben Dokument nachgetragen; jede KI
  darf dafür Problem-Dokumente anderer KIs aktualisieren.
- **Abhaken** (Tag `problem:resolved`) erst, wenn das Problem wirklich
  abgearbeitet und geprüft ist, mit Nachweis (Live-Abfrage, Test, Commit).
  Angestoßen, geplant oder „vermutlich behoben“ zählt nicht.
- Vor Arbeit an einem Thema zuerst nach `problem:open` suchen und dort
  weitermachen.
- Kanonischer Text: Dokument `governance-regel-problem-tracking` in Bank `luiz`.

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
einen festen Doppelnamen nach dem Schema **Kontoname-Ortsname**:

- Der **Kontoname** steht für das Konto bzw. Tool, über das die KI läuft.
- Der **Ortsname** steht für den Einsatzort innerhalb dieses Kontos.

So weiß jede Instanz beim Lesen dieser Datei, wie sie heißt. Das Schema gilt
für alle KIs, auch für künftige Konten und Tools.

| Kontoname | Konto / Tool |
|-----------|--------------|
| **Pia** | Claude über das Konto luizcarlhess@gmail.com |

| Ortsname | Einsatzort |
|----------|------------|
| **Kobalt** | Claude Code (Code-Bereich, lokal oder in der Cloud) |
| **Opal** | claude.ai-Chat, inkl. Projects wie "Kleine Anwendungen" |
| **Quarz** | Cowork |

Beispiele: **Pia-Kobalt** = Claude Code, **Pia-Opal** = claude.ai-Chat,
**Pia-Quarz** = Cowork.

Regeln:

- Jede KI kennt ihren vollen Namen, nennt sich selbst so und wird von Luiz
  nur mit diesem Namen angesprochen.
- Eine KI reagiert nur auf Nachrichten, die an ihren eigenen Namen gehen.
  Ist eine Nachricht an einen anderen Namen adressiert (z. B. "Pia-Quarz, …"
  in einer Pia-Kobalt-Session), führt sie nichts davon aus, sondern antwortet
  nur kurz, dass die Nachricht an jemand anderen gerichtet ist. Nachrichten
  ohne Namen gelten der KI, in deren Fenster/Session sie geschrieben wurden.
- Kommt ein neues Konto oder Tool hinzu (z. B. ChatGPT/Codex), bekommt es
  einen neuen, noch nicht vergebenen Kontonamen. Kommt ein neuer Einsatzort
  hinzu, bekommt er einen neuen Ortsnamen. Neue Namen dürfen nicht wie
  Menschen heißen, die Luiz kennt — deshalb keine Vornamen, sondern
  Mineralien/Gesteine (wie Kobalt, Opal, Quarz). Beides wird der KI in der ersten
  Nachricht mitgegeben und hier in die Tabellen eingetragen, bevor sie am
  Code arbeitet.
