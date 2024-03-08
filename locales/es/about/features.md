# Características

Por el momento, Lite XL ofrece un montón de funciones por defecto.

## Multiplataforma
Tenemos ejecutables para Windows, Linux y MacOS (con soporte para pantallas Retina).

## Ligero
El editor pesa 3MB y usa 10MB de RAM (y posiblemente menos).
No usamos Electron o WebView. Es solo Lua corriendo en un motor de renderizado.

## Extensible
Mientras que el editor es mínimo por defecto, es muy extensible con Lua.
De hecho, muchas funciones se proveen a través de plugins. Por ejemplo,
[intellisense parecido al de VSC](https://github.com/lite-xl/lite-xl-lsp).

## Mejor renderizado de fuentes
El editor se ve increíble en pantallas de cualquier tamaño.
También hay opciones configurables, como hinting y antialiasing.

## Edición multi-cursor
Puedes crear múltiples cursores usando `ctrl` + `lclick` sobre cualquier linea o `ctrl` + `shift` + `up`/`down`.

---

Estas son algunas funciones que no han sido implementadas junto a sus razones.
Algunos de estos pueden ser implementados vía plugins.
Te alentamos a que lo intentes.

## Renderizado acelerado por hardware
**tl;dr -  franko ha dicho que no planea usar OpenGL debido a las habilidades y el trabajo que implica.**

Se sugirió la aceleración por hardware en [esta discusión](https://github.com/lite-xl/lite-xl/discussions/450).
Takase intentó hacerlo 2 veces - primero usando [NanoVG](https://github.com/inniyah/nanovg)
y luego forzando a SDL a usar el renderizado por GPU.
En ambos intentos, las ganancias de rendimiento son, en el mejor de los casos insignificantes,
y en el peor de los casos el editor se vuelve completamente inutilizable.
Hemos decidido optimizar el renderizador de software y varias partes del código en Lua por el momento.

## Fuentes del sistema
Esto es dificil ya que varios sistemas tienen su propio mecanismo para manejar fuentes.
Por ahora, los usuarios pueden probar el [plugin `fontconfig`](https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/fontconfig.lua).
Fontconfig esta disponible en Linux e [instalable en MacOS](https://formulae.brew.sh/formula/fontconfig),
mientras que hay [ejecutables disponibles para Windows](https://github.com/takase1121/mingw-w64-fontconfig).
En el futuro, quizá consideremos agregar API para leer metadatos de fuentes, lo que nos permitirá escribir
una alternativa a fontconfig en Lua. (no prometemos nada :P)

## Abrir rutas UNC en Windows (unidades de red y acceso a archivos de WSL2 desde Windows)
El código que maneja la ubicación de archivos solo puede manejar rutas POSIX y Windows.
Tampoco estámos seguros de cómo reaccionará el editor ante estos escenarios.

## Comunicación entre ventanas (arrastrar pestañas entre ventanas y otras cosas)
Este es el más dificil de lograr. No tenemos intención de utilizar ningún kit de herramientas de widgets
(como Qt y GTK), que son necesarios para estas funciones. Una alternativa sería crear nuestro propio mecanismo de IPC,
pero eso sería [reinventar](https://es.wikipedia.org/wiki/D-Bus) [la](https://es.wikipedia.org/wiki/ICCCM) [rueda](https://github.com/swaywm/wlroots).

## Terminal integrada
Es complicado implementar una terminal.
Hay proyectos que _pueden_ ser portados a Lua, como [xterm.js](https://xtermjs.org).
Cualquier interesado lo puede intentar.
