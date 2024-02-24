# Systemschriftarten Benutzen

Lite XL bietet keinen Weg um Schriftarten vom System zu benutzen.
Weil _jede Platform die wir unterstützen (Windows, Linux und Mac)_ es anders macht.
Hier kommt [fontconfig][1] zur Rettung. fontconfig kann man auf verschiedene Betriebssysteme installieren.

lite-xl hat ein [fontconfig Plugin][2] dass wir benutzen können um Systemschriftarten zu finden.

## fontconfig Installieren
#### Windows
[mingw-w64-fontconfig][3] bietet einen Build, der direkt auf Windows benutzt werden kann.
Lade die Datei herunter, extrahiere es irgendwo und (optional) füge es zu den [PATH][4] hinzu.

#### Linux
Überprüfe distro-spezifische Anweisungen.

```sh
# ubuntu / debian
apt install fontconfig
# arch
pacman -Su fontconfig
# fedora
dnf install fontconfig
...
```

#### MacOS

```sh
brew install fontconfig
```

### Einstellen

1. Installiere das Plugin
2. Gebe es in dein Benutzer Modul:

```lua
local fontconfig = require "plugins.fontconfig"
fontconfig.use {
	 font = { name = "sans", size = 13 * SCALE },
	 code_font = { name = "monospace", size = 13 * SCALE }
}
```

`"sans"` und `"monospace"` kann eine beliebige [fontconfig Syntax][4] sein. (sehe "Font Names")


Beachte: Die Schriftart könnte nicht sofort laden (Weil wir auf `fc-match` warten müssen).
Wenn du es so haben willst, dann ersetze `fontconfig.use` mit `fontconfig.use_blocking`. Wenn du dass machst dann
muss lite-xl auf `fc-match` warten, was viel langsamer sein kann.


[1]: https://www.freedesktop.org/wiki/Software/fontconfig/
[2]: https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/fontconfig.lua
[3]: https://github.com/takase1121/mingw-w64-fontconfig
[4]: https://michster.de/wie-setze-ich-die-path-umgebungsvariablen-unter-windows-10/
[5]: https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
