# Funktionen

Momentan bietet Lite XL viele eingebaute Funktionen.

## Cross-Platform
Momentan unterstützen wir Windows, Linux und MacOS (Mit Unterschützung vom Retina-Display).

## Leicht
Wir sind momentan bei ungefähr 3MB in Größe und es braucht ungefähr 10MB in RAM (kann niedriger sein). Kein Electron / WebView ist involviert. Der ganze Editor läuft in Lua auf einer Rendering Engine.

## Erweiterbar
Der Editor is normalerweise minimal, es ist sehr erweiterbar mit Lua. Viele Funktionen werden von Plugins bereitgestellt. Zum Beispiel, [VSCode-ähnliche Intellisense](https://github.com/jgmdev/lite-xl-lsp).

## Betteres Schriftartenwiedergabe
Der Editor sieht auf jeder Bildschirmgröße gut aus. Paar andere Optionen sind auch konfigurierbar, wie zum Beispiel Hinting und Antialiasing.

## Multi-cursor Bearbeitung
Du kannst mehrere Cursor platzieren indem du `ctrl` + `lclick` oder `ctrl` + `shift` + `up` oder `ctrl` + `shift` + `down` drückst.

---


Hier sind ein paar Funktionen dass _nicht_ aus entsprechenden Gründen implementiert wurden.
Einige davon können durch Plugins implementiert werden.
Wir ermutigen dir es einen Versuch zu geben.

## Hardwarebeschleunigtes Rendering
** tl;dr Franko (Entwickler) gab an dass er nicht OpenGL benutzen wird wegen seiner Fähigkeiten und der verbundenen Arbeit.**

Hardwarebeschleunigen wurde in dieser [Diskussion](https://github.com/lite-xl/lite-xl/discussions/450) besprochen.
Takase (Entwickler) versuchte es zwei mal - zuerst mit [NanoVG](https://github.com/inniyah/nanovg) und dann durchs erzwingen von SDL GPU Rendering zu benutzen.
In beiden Versuchen war die Leistungsersteigerungen nicht bedeutend, im schlimmsten Fall war es komplet unverwendbar.
Gerade haben wir uns entschieden dass wir uns auf die Optimierung des Software-Renderers und mehrere Teile des Lua Codes konzentieren.

## Systemschriftarten
Dies ist schmerzhaft weil verschiedene Systeme ihren eigenen Mechanismus haben, wie sie Schriftarten verwalten.
Zur Zeit können Nutzer das [Fontconfig Plugin](https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/fontconfig.lua) benutzen.
Fontconfig ist auf Linux, [Windows](https://github.com/takase1121/mingw-w64-fontconfig) und [MacOS](https://formulae.brew.sh/formula/fontconfig) weit verbreitet.
In der Zukunft werden wir vielleicht eine API hinzufügen um Font Metadaten zu lesen, dass uns erlaubt eine Fontconfig Alternative in Lua zu schreiben (Kein Versprechen).

## Das Öffnen von UNC Pfaden auf Windows (Netzwerklaufwerke, Zugriff auf Windows WSL2 Dateien)
Unser Pfadumgangs Code kann nur mit POSIX- und Windowspfade umgehen.
Wir sind also nicht sicher wie sich Lite XL in diesen Szenarien verhält.

## Kommunikation Zwischen Fenstern (Tabs zwischen Fenstern ziehen und andere Magie)
Dies ist bei weitem am schwierigsten zu erreichen.
Lite XL hat keine Absicht auf irgendwelche Widget-Toolkits (Qt und GTK) zu verlinken, die für diese Funktionen gebraucht werden.
Eine Alterative wäre, unser Eigenes IPC Mechanismus zu erstellen, aber dass wäre [das](https://en.wikipedia.org/wiki/Inter-Client_Communication_Conventions_Manual) [Rad](https://github.com/swaywm/wlroots) [neu erfinden](https://en.wikipedia.org/wiki/D-Bus).

## Integriertes Terminal
Ein Terminal kann sehr schwer zum implementieren sein.
Es gibt Projekte dass man zu Lua porten kann, wie zum Beispiel [xterm.js](https://xtermjs.org/).
Wenn jemand interessiert ist, könnte es jemand machen.
