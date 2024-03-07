# Características

Por el momento, Lite XL ofrece un montón de funciones por defecto.

## Cross-Platform
Tenemos ejecutables para Windows, Linux y MacOS (con soporte para pantallas Retina).

## Ligero
El editor pesa 3MB y usa 10MB de RAM (y posiblemente menos).
No usamos Electron o WebView. Es solo Lua corriendo en un motor de renderizado.

## Extensible

Mientras que el editor es mínimo por defecto, es muy extensible con Lua.
De hecho, muchas funciones se proveen a través de plugins. Por ejemplo,
[intellisense parecido al de VSC](https://github.com/lite-xl/lite-xl-lsp)

## Better font rendering
El editor se ve increíble en pantallas de cualquier tamaño.
También hay opciones configurables, como hinting y antialiasing.

## Multi-cursor editing
Puedes crear múltiples cursores usando `ctrl` + `lclick` sobre cualquier linea
o `ctrl` + `shift` + `up` o `ctrl` + `shift` + `down`.


---

Estas son algunas funciones que no han sido implementadas junto a sus razones.
Algunos de estos pueden ser implementados vía plugins.
Te alentamos a que lo intentes.

## Renderizado acelerado por hardware
**tl;dr -  franko ha dicho que no planea usar OpenGL debido a las habilidades y el trabajo que implica.**

Se sugirió la aceleración por hardware en [esta](https://github.com/lite-xl/lite-xl/discussions/450) discusión.
Takase intentó hacerlo 2 veces - primero usando [NanoVG](https://github.com/inniyah/nanovg)
y luego forzando a SDL a usar el renderizado por GPU.
En ambos intentos, las ganancias de rendimiento en el mejor de los casos son insignificantes,
mientras que en el peor de los casos el editor se vuelve completamente inutilizable.
Hemos decidido optimizar el renderizador de software y varias partes del código en Lua por el momento.

## Fuentes del sistema.
Esto es dificil ya que varios sistemas tienen su propio mecanismo para manejar fuentes.
Por ahora, los usuarios pueden probar el [plugin `fontconfig`](https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/fontconfig.lua).
Fontconfig esta disponible en Linux e [instalable en MacOS](https://formulae.brew.sh/formula/fontconfig),
mientras que hay [ejecutables disponibles para Windows](https://github.com/takase1121/mingw-w64-fontconfig).
En el futuro, quizá consideremos agregar API para leer metadatos de fuentes, lo que nos permitirá escribir
una alternativa a fontconfig en Lua. (no prometemos nada :P)

## Opening UNC paths on Windows (network drives, accessing WSL2 files from Windows)
Our path handling code can only handle POSIX and Windows paths.
We also aren't sure how Lite XL will behave in these scenarios.

## Inter-window communication (dragging tabs between windows and other magic)
This is by far the hardest to achieve.
Lite XL has no intention to link to any widget toolkits (Qt and GTK) which are required for these features.
An alternative approach is to create our own IPC mechanism, but that's [reinventing](https://en.wikipedia.org/wiki/D-Bus) [the](https://en.wikipedia.org/wiki/Inter-Client_Communication_Conventions_Manual) [wheel](https://github.com/swaywm/wlroots).

## Integrated terminal
A terminal is complex to implement.
There are projects that _can_ be ported to Lua, such as [xterm.js](https://xtermjs.org/).
If someone is interested, they can do so.
