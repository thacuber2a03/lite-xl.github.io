# Nutzen

Lite XL ist ein leichter Texteditor dass größtensteils geschrieben in Lua - es zielt darauf ab etwas praktisches, schönes, *kleines* und schnelles zu bieten. 
So leicht wie möglich umgesetzt; leicht zur modifizieren und erweitern, oder zum Benutzen ohne beides zu machen.

Lite XL ist auf dem Lite Editor basiert und bietet paar Verbesserungen an
während es immernoch kompatible bleibt.

## Erste Schritte

Lite XL funktioniert mit *Projektverzeichnissen* - dies sind Ordnern indem der Code 
deines Projektes und andere Daten beinhaltet sind.

Um ein spezifisches Projektverzeichnis zu öffnen kann der Ordnername als Befehlzeilenargument angegeben werden. *(`.` kann angegeben werden um den jetzigen Ordner zu benutzen)*
oder der Ordner kann ins Fenster gezogen werden.

Einmal angefangen kann das Projektverzeichnis mit dem Befehl `core:change-project-folder` geändert werden. Der Befehl wird alle Dokumente schließen 
die zu Zeit offen sind und wechselt zum neuen Projektverzeichnis.

Wenn du ein neues Projektverzeichnis in einem neuen Fenster öffnen willst kannst du den Befehl `core:open-project-folder` ausführen.
Es wird ein neues Fenster mit dem ausgewählten Projektverzeichnis öffnen.

Die Hauptmethode um Dateien in Lite XL zu öffnen ist der Befehl `core:find-file` - 
dies bietet eine fuzzy finder über alle Dateien des Projekts an 
und kann mit dem `ctrl`+`p` Abkürzung geöffnet werden.

Befehle können durch Tastaturkürzel aktiviert werden, oder wenn man `core:find-command` benutzt.
Das `core:find-command` Befehl ist normalerweise an `ctrl`+`shift`+`p` gebunden. Zum Beispiel,
wenn man die Tastaturkürzel oben drückt und `newdoc` schreibt und dann `return` drückt, öffnet man ein neues Dokument.
Die eingestellte Tastaturkürzel für jedes Befehl kann man auf der rechten Seite des Namens sehen. Also kann man mit `ctrl`+`shift`+`p` drücken, um Tastaturkürzel für Befehle zu finden.

## Benutzerdatenverzeichnisse

Lite XL benutzt Standardsystembenutzerverzeichnisse; Die Nutzerdaten können in `$HOME/.config/lite-xl` auf Linux und MacOS gefunden werden.
Auf Windows wird das Variable `$USERPROFILE` anstatt `$HOME` benutzt.

## Benutzermodule

Lite XL wird durch Benutzermodule konfiguriert. Das Benutzermodul kann benutzt werden um neue Tastaturkürzel und
neue Farbschemen hinzuzufügen, oder den Stil oder andere Teile des Editors zu ändern.

Das Benutzermodul wird geladen nachdem die Anwendung gestartet wurde, nachdem Plugins geladen wurden.

Das Benutzermodul kann modifiziert werden indem man das `core:open-user-module` Befehl ausführt
sonst kann es auch modifiziert werden indem man die `$HOME/.config/lite-xl/init.lua` Datei öffnet.

Auf Windows wird das Variable `$USERPROFILE` anstatt `$HOME` benutzt.

**tl;dr:**

- Windows: `C:\Users\(username)\.config\lite-xl\init.lua`
- MacOS: `/Users/(usernmame)/.config/lite-xl/init.lua`
- Linux: `/home/(username)/.config/lite-xl/init.lua`

Dies sind nicht die genauen Orte, aber sie helfen dir sie zu finden.

Bitte bemerke dass Lite XLs Benutzermodul ein ganz anderen Ort hat als Lite Editors.

## Projektmodul

Das Projektmodul ist ein optionaler Modul der vom aktuellen Verzeichnis des Projekts geladen wird, wenn Lite XL startet.
Projektmodule können nützlich sein wenn man eigene Befehle für projektspezifische Befehle für Buildsysteme oder das Laden von projektspezifische Plugins braucht.

Nachdem die Plugins- und Benutzermodule geladen wurden,

Das Projektmodul kann editiert werden indem man `core:open-project-module` ausführt - Wenn das Modul nicht existiert, wird das Befehl eines erstellen.

## Füge Ordner zum Projekt hinzu

Es ist möglich andere Projektverzeichnisse hinzuzufügen indem man den `core:add-directory` Befehl ausführt.
Es wird auf der rechten Seite angezeigt werden und du kannst die Dateien im Ordner mit den `ctrl`+`p` Befehl auswählen.

Andere Projektverzeichnisse können mit dem `core:remove-directory` Befehl entfernt werden.

Wenn du dann Lite XL wiederöffnest werden die gleichen Projektverzeichnisse bleiben.
Die Anwendung merkt sich dein Arbeitsplatz und auch die hinzugefügten Projektverzeichnisse.

Seit Version 1.15 braucht Lite XL kein Arbeitsplatz Plugin, es ist ein Teil des Editors.

## Erstelle einen leeren Ordner

Mit dem `files:create-directory` Befehl oder control-click im Treeview kann man leere subordner erstellen.

## Befehle

Befehle werden im Befehlfinder und im Tastaturkürzelsystem von Lite XL benutzt.
Ein Befehl besteht aus diesen drei Komponenten:

* **Name** - der Befehl name in Form von `Namensraum:aktion-name`, z.B `doc:select-all`
* **Aussagen** - Eine Funktion die true zurückgibt wenn der Befehl ausgeführt werden kann, z.B für alle Dokumentenbefehle wird geschaut ob das ausgewählte View ein Dokument ist
* **Funktion** - Die Funktion die das Befehl ausführt

Befehle können hinzugefügt werden mit der `command.add` Funktion die vom `core.command` Modul bereitgestellt wird:

```lua
local core = require "core"
local command = require "core.command"

command.add("core.docview", {
  ["doc:save"] = function()
    core.active_view.doc:save()
    core.log("Saved '%s'", core.active_view.doc.filename)
  end
})
```

Befehle können programmatisch ausgeführt werden, indem man die `command.perform` Funktion vom `core.command` Modul benutzt:

```lua
local command = require "core.command"
command.perform "core:quit"
```

### Tastaturkürzel

Alle Tastaturkürzel werden vom `core.keymap` Modul verarbeitet.
Eine Tastaturkürzel verbindet ein "Kürzel" (z.B `ctrl`+`q`) mit ein oder mehreren Befehlen (z.B `core:quit`).
Wenn eine Tastaturkürzel gedrückt wird, iteratiert Lite XL über jedes Befehl dass zu dieser Tastaturkürzel zugewiesen wurde
und führt die *Aussage Funktion* für diesem Befehl aus - wenn eine Aussage erfolgreich ist, dann stoppt es die Iteration und führt den Befehl aus.

Ein Beispiel ist die `tab` Taste:

``` lua
  ["tab"] = { "command:complete", "doc:indent" },
```

Wenn Tab gedrückt wird, wird `command:complete` nur ausgeführt wenn die ausgewählte View das Befehleingang ist. Sonst
wird das `doc:indent` ausgeführt wenn das ausgewählte View das Dokument ist.

Ein neues Tastaturkürzel kann so in dein Benutzermodul hinzugefügt werden:

```lua
local keymap = require "core.keymap"
keymap.add { ["ctrl+q"] = "core:quit" }
```

Eine Liste der Standard Tastaturkürzel kann [hier][1] gefunden werden.

## Globale Variablen

Es gibt ein paar globale Variablen die vom Editor gesetzt werden.
Diese Variablen sind überall und sollten nicht überschrieben werden.

- `ARGS`: Befehlszeilenargumente. `argv[1]` ist der Name der Anwendung, `argv[2]` ist das erste Parameter, ...
- `PLATFORM`: Ausgabe von `SDL_GetPlatform()`. Kann `Windows`, `Mac OS X`, `Linux`, `iOS` und `Android` sein.
- `SCALE`: Schriftartengröße. Normalerweise 1, Aber kann bei HiDPI Systemen höher sein.
- `EXEFILE`: Absoluter Pfad zur ausführdatei.
- `EXEDIR`: Der ausführpfad. **Schreibe nicht zu diesem Ordner**
- `VERSION`: lite-xl Version.
- `MOD_VERSION`: mod-version die in Plugins benutzt wird. Wird geändert wenn die API sich ändert.
- `PATHSEP`: Pfad Trennzeichen. `\` (Windows) or `/` (Anderen Betriebssystemen)
- `DATADIR`: Der Daten Ordner, wo der Lua Teil von lite-xl ist. **Schreibe nicht zu diesem Ordner.**
- `USERDIR`: Benutzerkonfiguration Ordner.

> `USERDIR` soll anstatt `DATADIR` benutzet werden wenn man den Editor konfiguriert
> weil `DATADIR` vielleicht nicht schreibbar ist.
> (Zum Beispiel, wenn der Editor in `/usr` installiert ist, dann ist `DATADIR` in `/usr/share/lite-xl`!)
> `USERDIR` ist immer für den Nutzer schreibbar, es erlaubt mehrere Nutzer ihren Editor zu konfigurieren

## Plugins

Plugins in Lite XL sind normale Lua Module und werden auch so behandelt - Kein komplizierter Pluginmanager wird bereitgestellt, und wenn einmal ein Plugin geladen ist, kann es sich nicht selber entladen.

Um ein Plugins zu installieren kannst du es einfach im `plugins` Ordner im Benutzermodulordner reingeben.
Wenn Lite XL startet, ladet es zuerst die Plugins im Datenordner, dann wird es die Plugins im Benutzermodulordner laden.

Um ein Plugin zu deinstallieren, kann man einfach die Plugin Datei löschen - alle Plugins 
(Auch die was mit dem Editor installiert kommen) können gelöscht werden, um ihre Funktionen zu entfernen.

Wenn du Plugins nur unter bestimmten Umstanden laden willst (z.B nur in einem bestimmen Project), 
dann kann der Plugin irgendwo außer im `plugins` Ordner gegeben werden. Der Plugin kann dann manuell geladen werden mit der
`require` Funktion.

Plugins können vom [Plugins Repository][2] heruntergeladen werden.

## Den Editor neustarten

Wenn du eine Benutzerkonfiguration Datei oder eine Lua Implementation Datei modifizierst, 
dann kannst du mit `core:restart` Befehl den Editor neustarten.
Die ganze Anwendung wird neugeladen indem es ein existierendes Fenster neustartet.

## Color Themes

Farbthemen in Lite XL sind Lua Module die Farbfelder von Lite XLs `core.style` Modul überschreiben.
Vordefinierte Farbenmethoden sind im `colors` Ordner im Datenordner.
Neue Farbthemen können installiert werden im `colors` Ordner dass in dein Benutzermodulordner ist.

Ein Farbthema kann benutzt werden indem man es in dein Benutzermodulordner erfordert:

```lua
core.reload_module "colors.winter"
```

Im Lite Editor wird die `require` funktion benutzt anstatt `core.reload_module`.
In Lite XL soll `core.reload_module` benutzt werden um sicher zu sein, dass ein Farbmodul echt neugeladen wird,
wenn man die Benutzerkonfiguration speichert.

Farbthemen können vom [Farbthemen Repository][3] heruntergeladen werden.
Sie sind in Lite XL Veröffentlichungpacketen enthalten.


[1]: /de/documentation/keymap
[2]: https://github.com/lite-xl/lite-xl-plugins
[3]: https://github.com/lite-xl/lite-xl-colors
