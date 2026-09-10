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
