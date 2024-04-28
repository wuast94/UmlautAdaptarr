# UmlautAdaptarr

## English description coming soon

## Beschreibung
Wer möchte kann den UmlautAdaptarr jetzt gerne testen! Über Feedback würde ich mich sehr freuen!

Es sollte mit allen *arrs funktionieren, hat aber nur bei Sonarr, Readarr und Lidarr schon Auswirkungen (abgesehen vom Caching).

UmlautAdaptarr löst mehrere Probleme:
- Releases mit Umlauten werden grundsätzlich nicht korrekt von den *Arrs importiert
- Releases mit Umlauten werden oft nicht korrekt gefunden (*Arrs suchen nach "o" statt "ö" & es fehlt häufig die korrekte Zuordnung zur Serie/zum Film beim Indexer)
- Sonarr & Radarr erwarten immer den englischen Titel von https://thetvdb.com/ bzw. https://www.themoviedb.org/. Das führt bei deutschen Produktionen oder deutschen Übersetzungen oft zu Problemen - falls die *arrs schon mal etwas mit der Meldung `Found matching series/movie via grab history, but release was matched to series by ID. Automatic import is not possible/` nicht importiert haben, dann war das der Grund.
- Zusätzlich werden einige andere Fehler behoben, die häufig dazu führen, dass Titel nicht erfolgreich gefunden, geladen oder importiert werden.

## Wie macht UmlautAdaptarr das?
UmlautAdaptarr tut so, als wäre es ein Indexer. In Wahrheit schaltet sich UmlautAdaptarr aber nur zwischen die *arrs und den echten Indexer und kann somit die Suchen sowie die Ergebnisse abfangen und bearbeiten.
Am Ende werden die gefundenen Releases immer so umbenannt, dass die Arrs sie einwandfrei erkennen.
Einige Beispiele finden sich [weiter unten](https://github.com/PCJones/UmlautAdaptarr/edit/develop/README.md#beispiel-funktionalit%C3%A4t).


## Features

| Feature                                                           | Status        |
|-------------------------------------------------------------------|---------------|
| Prowlarr & NZB Hydra Support                                                    | ✓|
| Sonarr Support                                         | ✓             |
| Lidarr Support                                                    | ✓|
| Readarr Support                                                   | ✓       |
| Releases mit deutschem Titel werden erkannt   | ✓             |
| Releases mit TVDB-Alias Titel werden erkannt  | ✓             |
| Korrekte Suche und Erkennung von Titel mit Umlauten                            | ✓             |
| Anfragen-Caching für 12 Minuten zur Reduzierung der API-Zugriffe   | ✓             |
| Usenet (newznab) Support                                          |✓|
| Torrent (torznab) Support                                         |✓|
| Support von meheren *arrs Instanzen                               | ✓             
| Radarr Support                                                    | Geplant       |
| Prowlarr Unterstützung für "DE" SceneNZBs Kategorien              | Geplant       |
| Unterstützung weiterer Sprachen neben Deutsch                     | Geplant       |
| Wünsche?                                                          | Vorschläge?   |


## Installation
Momentan ist Docker dafür nötig, wer kein Docker nutzt muss sich noch etwas gedulden. Eine Unraid-App gibt es auch, einfach nach `umlautadaptarr` suchen.

[Link zum Docker Image](https://hub.docker.com/r/pcjones/umlautadaptarr)

Nicht benötigte Umgebungsvariablen, z.B. wenn Readarr oder Lidarr nicht benötigt werden, können entfernt werden.

### Konfiguration in Prowlarr (**empfohlen**)
Das ist die **empfohlene** Methode um den UmlautAdaptarr einzurichten. Sie hat den Vorteil, dass es, sofern man mehrere Indexer nutzt, keinen Geschwindigkeitsverlust bei der Suche geben sollte.

1) In Prowlarr: Settings>Indexers bzw. Einstellungen>Indexer öffnen
2) Lege einen neuen HTTP-Proxy an:

![Image](https://github.com/PCJones/UmlautAdaptarr/assets/377223/b97418d8-d972-4e3c-9d2f-3a830a5ac0a3)

- Name: UmlautAdaptarr HTTP Proxy (Beispiel)
- Port: `5006` (Port beachten!) 
- Tag: `umlautadaptarr`
- Host: Je nachdem, wie deine Docker-Konfiguration ist, kann es sein, dass du entweder `umlautadaptarr` oder `localhost`, oder ggf. die IP des Host setzen musst. Probiere es sonst einfach aus, indem du auf Test klickst.
- Die Username- und Passwort-Felder können leergelassen werden.
3) Gehe zur Indexer-Übersichtsseite
4) Für alle Indexer/Tracker, die den UmlautAdaptarr nutzen sollen:

![grafik](https://github.com/PCJones/UmlautAdaptarr/assets/377223/3daea3f1-7c7b-4982-84e2-ea6a42d90fba)

  - Füge den `umlautadaptarr` Tag hinzu
  - **Wichtig:** Ändere die URL von `https` zu `http`. (Dies ist erforderlich, damit der UmlautAdaptarr die Anfragen **lokal** abfangen kann. **Ausgehende** Anfragen an den Indexer verwenden natürlich weiterhin https).
5) Klicke danach auf `Test All Indexers` bzw `Alle Indexer Testen`. Falls du irgendwo noch `https` statt `http` stehen hast, sollte in den UmlautAdaptarr logs eine Warnung auftauchen. Mindestens solltest du aber noch ein zweites Mal alle Indexer durchgehen und überprüfen, ob überall `http` eingestellt ist - Indexer, bei denen noch `https` steht, werden nämlich einwandfrei funktionieren - allerdings ohne, dass der UmlautAdaptarr bei diesen wirken kann.

### Konfiguration in Sonarr/Radarr oder Prowlarr ohne Proxy
Falls du kein Prowlarr nutzt oder nur 1-3 Indexer nutzt, kannst du diese alternative Konfigurationsmöglichkeit nutzen.

Dafür musst du einfach nur alle Indexer, bei denen der UmlautAdaptarr greifen soll, bearbeiten:

Am Beispiel von sceneNZBs:

![grafik](https://github.com/PCJones/UmlautAdaptarr/assets/377223/07c7ca45-e0e5-4a82-af63-365bb23c55c9)

Also alles wie immer, nur dass als API-URL nicht direkt z.B. `https://scenenzbs.com` gesetzt wird, sondern 
`http://localhost:5005/_/scenenzbs.com`

Der API-Key muss natürlich auch ganz normal gesetzt werden.

## Beispiel-Funktionalität
In den Klammern am Ende des Releasenamens (Bild 2 & 4) steht zu Anschauungszwecken der deutsche Titel der vorher nicht gefunden bzw. akzeptiert wurde. Das bleibt natürlich nicht so ;)

**Vorher:** Release wird zwar gefunden, kann aber kann nicht zu geordnet werden.
![Vorherige Suche ohne deutsche Titel](https://github.com/PCJones/UmlautAdaptarr/assets/377223/1fce2909-a36c-4f1b-8497-85903357fee3)

**Jetzt:** 2-3 weitere Releases werden gefunden, außerdem meckert Sonarr nicht mehr über den Namen und würde es bei einer automatischen Suche ohne Probleme importieren.
![Jetzige Suche mit deutschen Titeln](https://github.com/PCJones/UmlautAdaptarr/assets/377223/0edf43ba-2beb-4f22-aaf4-30f9a619dbd6)


**Vorher:** Es werden nur Releases mit dem englischen Titel der Serie gefunden
![Vorherige Suche, englische Titel](https://github.com/PCJones/UmlautAdaptarr/assets/377223/ed7ca0fa-ac36-4584-87ac-b29f32dd9ace)

**Jetzt:**  Es werden auch Titel mit dem deutschen Namen gefunden :D
![Jetzige Suche, deutsche und englische Titel](https://github.com/PCJones/UmlautAdaptarr/assets/377223/1c2dbe1a-5943-4fc4-91ef-29708082900e)


**Vorher:** Die deutsche Produktion `Alone - Überlebe die Wildnis` hat auf [TheTVDB](https://thetvdb.com/series/alone-uberlebe-die-wildnis) den Englischen Namen `Alone Germany`.

Sonarr erwartet immer den Englischen Namen, der hier natürlich nicht gegeben ist.
![grafik](https://github.com/PCJones/UmlautAdaptarr/assets/377223/62158f77-ecc2-4747-af85-4b8f94f51ab4)

**Jetzt:** UmlautAdaptarr hat die Releases in `Alone Germany` umbenannt und Sonarr hat keine Probleme mehr
![grafik](https://github.com/PCJones/UmlautAdaptarr/assets/377223/57539ffc-b8a6-4255-a7f8-03079c10b1e8)

**Vorher:** Hier wird der komplette deutsche Titel im Release angegeben (also mit `- Das Lied von Eis und Feuer`) - glücklicherweise stellt uns [TheTVDB](https://thetvdb.com/series/game-of-thrones) aber diesen längeren Titel als Alias zur Verfügung - nur nutzt Sonarr diese Informationen (bisher) einfach nicht.
![grafik](https://github.com/PCJones/UmlautAdaptarr/assets/377223/8f3297bd-ebe4-42de-b4e6-952882c8b902)

**Jetzt:** UmlautAdapatarr erkennt alle auf TheTVDB angegebenen Aliase und benennt das Release in den Englischen Titel um
![grafik](https://github.com/PCJones/UmlautAdaptarr/assets/377223/52f0caf5-6e9d-442e-9018-ba29f954a890)

## Kontakt & Support
- Öffne gerne ein Issue auf GitHub falls du Unterstützung benötigst.
- [Telegram](https://t.me/pc_jones)
- Discord: pcjones1 - oder komm in den UsenetDE Discord Server: [https://discord.gg/pZrrMcJMQM](https://discord.gg/pZrrMcJMQM)

## Spenden
Über eine Spende freue ich mich natürlich immer :D
PayPal: https://paypal.me/pcjones1

Für andere Spendenmöglichkeiten gerne auf Discord oder Telegram melden - danke!

### Licenses & Metadata source
- TV Metadata source: https://thetvdb.com
- Movie Metadata source: https://themoviedb.org
- Licenses: TODO
