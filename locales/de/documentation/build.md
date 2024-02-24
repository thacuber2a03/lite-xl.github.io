# Bauen

Wenn du dann den Quellcode hast, kannst du Lite XL mit Meson für dich selber bauen.
Zusätzlich gibt es das `build-packages.sh` Script dass benutzt werden kann, um Lite XL zu kompilieren und
ein Betriebsystemspezifisches Packet für Linux, Windows oder MacOS zu erstellen.

Die folgenen Bibliotheken werden gebraucht:

- freetype2
- SDL2

Die folgenden Bibliotheken sind **optional**:

- libagg
- Lua 5.2

Wenn sie nicht gefunden werden können, werden sie von Meson heruntergeladen und kompiliert.
Sonst wenn sie present sind, werden sie benutzt um Lite XL zu bauen.

## Bau Script

Wenn du Lite XL selber kompilieren willst, 
ist es empfohlen, den `build-packages.sh` Script zu benutzen:

```bash
bash build-packages.sh -h
```

Der Script wird Meson ausführen und erstellt ein tar komprimiertes Archiv mit der Anwendung, oder
für Windows, eine zip Datei. Lite XL kann leicht installiert werden, indem man das Archiv auspackt.

Unter Windows werden zwei Packete erstellt, eines heißt "portable" dass den Datenordner neben der Ausführbarendatei haben wird.
Das andere Packet benutzt ein unix-ähnlichen Layout, es ist gemeint für die Leute, die ein unix-ähnliches Shell und Befehlszeile benutzen.

Bitte bemerke dass es keine fest codierte Ordner in der Ausführenbarendatei gibt, also können Packete in allen Ordnern benutzt werden.

## Portable

Wenn man `meson setup` ausführt, gibt es eine Option `-Dportable=true` die sagt, ob Dateien als tragbare Anwendung installiert werden soll.

Wenn `portable` berechtigt wurde, wird Lite XL den Datenordner neben der Anwendung platzieren.
Sonst wird Lite XL Unix-ähnliche Ordner benutzen.
In diesen fall wird der Datenordner in `$prefix/share/lite-xl` sein und die Anwendung wird in `$prefix/bin` sein.
`$prefix` wird bestimmt wenn die Anwendung in einem Ordner wie `$prefix/bin` gestartet wird.

Der Benutzermodulordner hängt nicht von der `portable` Option ab und wird immer `$HOME/.config/lite-xl` sein.
Auf Windows wird das Variable `$USERPROFILE` benutzt.

## Linux

Auf Debianbasierten Systemen können die gebrauchten Bibliotheken und Meson mit den folgenden Befehlen installiert werden:

```bash
# Um die gebrauchten Bibliotheken zu installieren:
sudo apt install libfreetype6-dev libsdl2-dev

# Um Meson zu installieren:
sudo apt install meson
# or pip3 install --user meson
```

Um Lite XL mit Meson zu bauen werden die folgenden Befehle benutzt:

```bash
meson setup --buildtype=release --prefix <prefix> build
meson compile -C build
DESTDIR="$(pwd)/lite-xl" meson install --skip-subprojects -C build
```

Wo `<prefix>` ist, hängt von dein Betriebssystem ab:
- Auf Linux ist es in `/usr` sein
- Auf MacOS kann es in `"/Lite XL.app"` sein

Wenn du eine Version von Meson benutzt die unter 0.54 ist, musst du andere Befehle benutzen:

```bash
meson setup --buildtype=release build
ninja -C build
ninja -C build install
```

## MacOS

MacOS ist voll unterstützt und eine notarierte App-Disk-Image ist auf der [Veröffenlichungsseite][1] bereitgestellt.
Die Anwendung kann mit den Schritten oben kompiliert werden.

## Windows MSYS2

Die Bauumgebung für Lite XL auf Windows ist [MSYS2][2].
Folge die Installationsschritte im Link.

- Öffne `MinGW 64-bit` oder `MinGW 32-bit` vom Startmenü
- Aktualisiere die "MSYS" Installation mit `pacman -Syu`
- Starte Shell neu
- Installiere die Abhängigkeiten:

```sh
pacman -S \
  ${MINGW_PACKAGE_PREFIX}-freetype \
  ${MINGW_PACKAGE_PREFIX}-gcc \
  ${MINGW_PACKAGE_PREFIX}-ninja \
  ${MINGW_PACKAGE_PREFIX}-pcre2 \
  ${MINGW_PACKAGE_PREFIX}-pkg-config \
  ${MINGW_PACKAGE_PREFIX}-python-pip \
  ${MINGW_PACKAGE_PREFIX}-SDL2
pip3 install meson
```

`${MINGW_PACKAGE_PREFIX}` ist entweder auf `mingw-w64-i686` oder `mingw-w64-x86_64`
abhängig ob deine Shell 32- oder 64bit ist.

[1]: https://github.com/lite-xl/lite-xl/releases/latest/
[2]: https://www.msys2.org/
