# Zeiterfassung (Zeitkonto)

Eine einzelne HTML-Datei (`index.html`) als leichte, offline-fähige Zeiterfassungs-App im Browser. Kein Server, kein Build-Schritt — Daten werden lokal im `localStorage` des Browsers gespeichert.

## Funktionen

- **Start/Stop-Uhr** je Kategorie, mit laufender Anzeige seit Beginn
- **Kategorien verwalten** (Name, Farbe) — bereits erfasste Einträge bleiben auch nach Löschen einer Kategorie erhalten
- **Wochen-/Monatsübersicht** der Gesamtzeiten je Kategorie
- **Verlauf** aller Einträge, gruppiert nach Tag
- **Manuelle Nacherfassung** für vergessene oder zu korrigierende Zeiten
- **Excel-Export** der eigenen Daten (client-seitig über [SheetJS](https://sheetjs.com))
- **Cloud-Sync (optional)**: Jeder Stopp kann automatisch an eine gemeinsame Google-Tabelle gesendet werden (via Google Apps Script Web-App-URL); nützlich, wenn mehrere Personen in dieselbe Tabelle eintragen
- **Standort-Automatik (optional)**: Start/Stop kann automatisch anhand gespeicherter Orte (Geofencing) ausgelöst werden, solange die Seite geöffnet ist

## Nutzung

1. `index.html` im Browser öffnen (lokal per Doppelklick oder über GitHub Pages gehostet).
2. Auf dem Handy: Seite öffnen und über "Zum Home-Bildschirm hinzufügen" wie eine App installieren.
3. Kategorie auswählen, "Start" drücken — fertig.

## Daten und Datenschutz

Alle Daten (Kategorien, Sitzungen, Orte, Sync-Einstellungen) liegen ausschließlich im `localStorage` des jeweiligen Geräts/Browsers. Es gibt keinen eigenen Server; die einzige externe Verbindung ist der optionale, selbst konfigurierte Google-Sheet-Sync-Endpunkt.

## Technik

- Reines HTML/CSS/JavaScript, keine Abhängigkeiten außer der [SheetJS](https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js)-CDN für den Excel-Export.
- Kein Build-Prozess, keine Installation nötig.
