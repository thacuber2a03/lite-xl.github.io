# Resaltado de sintaxis

## Cómo crear plugins de resaltado de sintaxis para Lite XL

Los plugins de resaltado de sintaxis para Lite XL son sólo archivos de Lua.
Estos definen patrones o expresiones regulares que marcan ciertas partes
de un lenguaje específico, asignando tipos de "tokens" a cada coincidencia.
A estos tipos de token luego se les da colores diferentes de acuerdo a tu
tema de colores actual.

Como otros plugins, las definciónes de sintaxis se toman de los siguientes
directorios, en orden:

- `/usr/share/lite-xl/plugins/`
- `$HOME/.config/lite-xl/plugins/`

NOTA: El lugar exacto de estos directorios dependerá de tu sistema operativo
y método de instalación. Por ejemplo, en Windows se usará la variable
`$USERPROFILE` en lugar de `$HOME`.

El directorio de configuración del usuario para Lite XL generalmente se
encuentra en estos lugares en diferentes sistemas operativos:

- Windows: `C:\Users\(nombre de usuario)\.config\lite-xl`
- MacOS: `/Users/(nombre de usuario)/.config/lite-xl`
- Linux: `/home/(nombre de usuario)/.config/lite-xl`

Así que para crear una nueva definición de sintaxis en Linux, puedes sólo crear
un archivo `.lua` en el directorio `$HOME/.config/lite-xl/plugins`.

## ¿Qué tipos de token se pueden usar?

Los tipos de token reservados, definidos por `lite-xl/core/style.lua`, son:

- normal
- symbol (símbolos)
- comment (comentarios)
- keyword (palabras clave)
- keyword2 (otros tipos de palabras clave, como `self` en Lua)
- number (números)
- literal (valores literales, como `true` y `false` en Lua)
- string
- operator (operadores)
- function (definiciones, declaraciónes o llamadas a funciones)

En tu plugin de resaltado de sintaxis escribes patrones para marcar partes de la
sintaxis del lenguaje, y asignarles tipos de token. No tienes que usar todos.
Sólo los que necesites para tu lenguaje.

Vamos a través de una definición de sintaxis de ejemplo para ver como funcionan.

## Sintaxis de ejemplo: archivos de configuración de SSH

Este es un pequeño y simple ejemplo de una definición de sintaxis.
Sirve para resaltar archivos de configuración de SSH y se ve así:

```lua
-- mod-version:2 -- lite-xl 2.0
local syntax = require "core.syntax"

syntax.add {
  files = { "sshd?/?_?config$" },
  comment = '#',
  patterns = {
    { pattern = "#.*\n",        type = "comment"  },
    { pattern = "%d+",          type = "number"   },
    { pattern = "[%a_][%w_]*",  type = "symbol"   },
    { pattern = "@",            type = "operator" },
  },
  symbols = {
    -- configuración de ssh
    ["Host"]                         = "function",
    ["ProxyCommand"]                 = "function",

    ["HostName"]                     = "keyword",
    ["IdentityFile"]                 = "keyword",
    ...

    -- configuración de sshd
    ["Subsystem"]                    = "keyword2",

    -- literales
    ["yes"]      = "literal",
    ["no"]       = "literal",
    ["any"]      = "literal",
    ["ask"]      = "literal",
  },
}
```

Veamos cada sección y averigüemos como funciona.

### Cabecera

La primera linea es un comentario de Lua y le dice a Lite XL qué versión requiere este plugin.
La segunda importa el módulo `core.syntax`:

```lua
-- mod-version:2 -- lite-xl 2.0
local syntax = require "core.syntax"
```

Luego agregamos una definición de sintaxis al editor utilizando `syntax.add {...}`.
El contenido de esta definición se cubre debajo.

#### Archivos

El campo `files` le avisa a Lite XL en cuáles archivos se debe usar esta sintaxis.
Este es un patrón de Lua que revisa el nombre completo del archivo siendo abierto.
Por ejemplo, para asignar una sintaxis a archivos de Markdown - con extensiones
`.md` o `.markdown`, puedes hacer esto:

```lua
files = { "%.md$", "%.markdown$" },
```

En el ejemplo anterior coincidimos con el final de la ubicación en vez de la extension,
porque los archivos de configuración de SSH no tienen extensiones - y no queremos resaltar
todos los archivos que terminen en `config`. Esperamos que la ubicación de los archivos
de configuración se parezca a alguno de estos:

- `~/.ssh/config`
- `/etc/ssh/ssh_config`
- `/etc/ssh/sshd_config`

Este patrón coincide con ubicaciones que se parezcan a esas:

```lua
files = { "sshd?/?_?config$" },
```

### Comentarios

El campo `comment` _no_ define cuáles partes de la sintaxis son comentarios - revisa Patrones para eso, justo debajo.
Este campo le dice a Lite XL qué caracteres insertar al comienzo de las lineas seleccionadas al presionar `ctrl`+`/`.
También puedes añadir el campo `block_comment` para decirle a Lite XL como crear comentarios de bloque / multilínea.

### Patrones

Un cierto pedazo de texto solo puede coincidir con un patrón. Una vez que Lite XL decida que una pieza de texto coincide con
un patrón, le asignará ese tipo de token al texto y continuará con el resto. Los patrones se revisan en el orden en el cual
están escritos, así que la primera coincidencia gana.

Cada patron toma una de las siguientes formas:

#### Patrón simple

```lua
{ pattern = "#.*\n",        type = "comment" },
```

Esta forma compara la línea con el patrón, y si coinciden, le asigna al pedazo de texto el tipo de token en `type` - `comment`, en este caso.

#### Patrón de rango

```lua
{ pattern = { "%[", "%]" }, type = "keyword" },
```

Esta forma tiene dos patrones - una que revisa el comienzo del rango y una que revisa el final.
A todo lo que se encuentra en medio de estos se le asigna el tipo en `type`.

#### Patrón de rango con escape

```lua
{ pattern = { '"', '"', '\\' }, type = "string" },
```

Igual a la forma anterior, pero con un patrón extra. Este patrón, el de `'\\'` en este caso,
especifica el caracter que permite escapar el patrón final.

Para más información acerca de patrones en Lua, revisa: [Lua Pattern Reference](https://www.lua.org/manual/5.3/manual.html#6.4.1)

Si necesitas usar expresiones regulares PCRE, en lugar de patrones de Lua, sustituye `pattern` por `regex`.

### Símbolos

> Esto **no esta relacionado al tipo de token `symbol`.**

La tabla de símbolos te permite asignarles tipos de token a palabras clave especificas o a pedazos de texto -
usualmente siendo palabras reservadas en el lenguaje que estas resaltando.
El tipo de token en esta sección **siempre precede** sobre los otros tipos de token declarados en `patterns`.

Por ejemplo, esto resalta `Host` usando el tipo `function`, `HostName` como `keyword`, y `yes`, `no`, `any` y `ask` como `literal`es:

```lua
["Host"]                         = "function",
["HostName"]                     = "keyword",

["yes"]      = "literal",
["no"]       = "literal",
["any"]      = "literal",
["ask"]      = "literal",
```

#### Tip: ¡revisa tus patrones!

Hay errores comunes que pueden ser cometidos al usar la tabla de símbolos en conjunción con los patrones.

##### Caso 1: Espacios entre dos tokens de tipo `symbol`

Aquí hay un ejemplo:

```lua
{ pattern = "[%a_][%w_]+%s+()[%a_][%w_]+", type = { "keyword2", "symbol" } }
```

Expliquemos un poco el patrón (omitiendo los parentesis vacíos):

```
[%a_] = cualquier letra y guión bajo
[%w_] = cualquier letra, dígito y guión bajo
%s = cualquier letra de espacio

PALABRA =
  [%a_] seguido de (1 o más [%w_])

patrón =
  PALABRA seguida de (uno o más %s) seguido de PALABRA
```

Un poco más tarde le agregas una entrada a la tabla de símbolos: `["mi"] = "literal"`.
Pruebas la sintaxis con `mi función` y notas que `"mi"` no se resalta como `literal`. ¿Porqué occurió eso?

**La tabla de símbolos requiere una coincidencia exacta.**
Si miras cuidadosamente, los parentesis vacíos (`()`) están puestos **luego del espacio**!
Esto le dice a Lite XL que `PALABRA seguida de (una o más %s)` es un token, lo que marcará `mi ` (nota el espacio en el texto).

Para arreglarlo, tienes que añadir un token `normal` en el espacio entre los dos tokens:

```lua
{ pattern = "[%a_][%w_]+()%s+()[%a_][%w_]+", type = { "keyword2", "normal", "symbol" } }
```

##### Caso 2: Patrones y tokens `symbol`

Quizás asumas que Lite XL mágicamente compara el texto contra la tabla de símbolos. Este no es el caso.

En algunos lenguajes, las personas quizás agreguen un patrón genérico para delegar el marcado a la tabla de símbolos.

```lua
{ pattern = "[%a_][%w_]*", "symbol" }
```

Pero la tabla de símbolos puede que se vea así:

```lua
symbols = {
  ["mi-simbolo"] = "function",
  ["..algo_mas"] = "literal"
}
```

`"mi-simbolo"` contiene un guión (`-`) y `"..algo_mas"` contiene 2 puntos (`.`).
¡Ninguno de esos caracteres coincide con el patrón `[%a_][%w_]*`!

**Cuidado con el texto que quieres marcar en la tabla de símbolos.**
**Si vas a usarla, asegúrate de que puede coincidir con alguno de los patrones.**

Los patrones correctos son:

```lua
{ pattern = "[%a_][%w%-_]*", "symbol" },
{ pattern = "%.%.[%a_][%w_]*", "symbol" },
```

## Probando tu nueva sintaxis

Para probar tu nuevo resaltador de sintaxis tienes que hacer dos cosas:

- Reiniciar el editor.
- Cargar un archivo en el lenguaje que escogiste.

Para reiniciar el editor, puedes reiniciarlo de la manera normal, o puedes recargar el núcleo desde el buscador de comandos.
Para hacer esto, presiona `ctrl`+`shift`+`p` para mostrar el buscador de comandos y luego selecciona `Core: Restart`
(o escribe `crr` o algo parecido para marcarlo), y luego presiona Enter. Tendrás que reiniciar el núcleo luego de cualquier
cambio que le hagas a la definición de tu resaltador de sintaxis.

## Ejemplo de sintaxis avanzada: Markdown

> **Nota: Este ejemplo tiene características de 2.1. No es compatible con versiones más antiguas de Lite XL.**

No todos los lenguajes son tan simples como los archivos de configuración de SSH.
Lenguajes de marcado como HTML y Markdown son especialmente difíciles de resaltar correctamente.
Aquí está el archivo resaltador de Markdown en todo su esplendor:

```lua
-- mod-version:3
local syntax = require "core.syntax"
local style = require "core.style"
local core = require "core"

local initial_color = style.syntax["keyword2"]

-- Add 3 type of font styles for use on markdown files
for _, attr in pairs({"bold", "italic", "bold_italic"}) do
  local attributes = {}
  if attr ~= "bold_italic" then
    attributes[attr] = true
  else
    attributes["bold"] = true
    attributes["italic"] = true
  end
  -- no way to copy user custom font with additional attributes :(
  style.syntax_fonts["markdown_"..attr] = renderer.font.load(
    DATADIR .. "/fonts/JetBrainsMono-Regular.ttf",
    style.code_font:get_size(),
    attributes
  )
  -- also add a color for it
  style.syntax["markdown_"..attr] = style.syntax["keyword2"]
end

local in_squares_match = "^%[%]"
local in_parenthesis_match = "^%(%)"

syntax.add {
  name = "Markdown",
  files = { "%.md$", "%.markdown$" },
  block_comment = { "<!--", "-->" },
  space_handling = false, -- turn off this feature to handle it our selfs
  patterns = {
  ---- Place patterns that require spaces at start to optimize matching speed
  ---- and apply the %s+ optimization immediately afterwards
    -- bullets
    { pattern = "^%s*%*%s",                 type = "number" },
    { pattern = "^%s*%-%s",                 type = "number" },
    { pattern = "^%s*%+%s",                 type = "number" },
    -- numbered bullet
    { pattern = "^%s*[0-9]+[%.%)]%s",       type = "number" },
    -- blockquote
    { pattern = "^%s*>+%s",                 type = "string" },
    -- alternative bold italic formats
    { pattern = { "%s___", "___%f[%s]" },   type = "markdown_bold_italic" },
    { pattern = { "%s__", "__%f[%s]" },     type = "markdown_bold" },
    { pattern = { "%s_[%S]", "_%f[%s]" },   type = "markdown_italic" },
    -- reference links
    {
      pattern = "^%s*%[%^()["..in_squares_match.."]+()%]: ",
      type = { "function", "number", "function" }
    },
    {
      pattern = "^%s*%[%^?()["..in_squares_match.."]+()%]:%s+.+\n",
      type = { "function", "number", "function" }
    },
    -- optimization
    { pattern = "%s+",                      type = "normal" },

  ---- HTML rules imported and adapted from language_html
  ---- to not conflict with markdown rules
    -- Inline JS and CSS
    {
      pattern = {
      "<%s*[sS][cC][rR][iI][pP][tT]%s+[tT][yY][pP][eE]%s*=%s*" ..
        "['\"]%a+/[jJ][aA][vV][aA][sS][cC][rR][iI][pP][tT]['\"]%s*>",
      "<%s*/[sS][cC][rR][iI][pP][tT]>"
      },
      syntax = ".js",
      type = "function"
    },
    {
      pattern = {
      "<%s*[sS][cC][rR][iI][pP][tT]%s*>",
      "<%s*/%s*[sS][cC][rR][iI][pP][tT]>"
      },
      syntax = ".js",
      type = "function"
    },
    {
      pattern = {
      "<%s*[sS][tT][yY][lL][eE][^>]*>",
      "<%s*/%s*[sS][tT][yY][lL][eE]%s*>"
      },
      syntax = ".css",
      type = "function"
    },
    -- Comments
    { pattern = { "<!%-%-", "%-%->" },   type = "comment" },
    -- Tags
    { pattern = "%f[^<]![%a_][%w_]*",    type = "keyword2" },
    { pattern = "%f[^<][%a_][%w_]*",     type = "function" },
    { pattern = "%f[^<]/[%a_][%w_]*",    type = "function" },
    -- Attributes
    {
      pattern = "[a-z%-]+%s*()=%s*()\".-\"",
      type = { "keyword", "operator", "string" }
    },
    {
      pattern = "[a-z%-]+%s*()=%s*()'.-'",
      type = { "keyword", "operator", "string" }
    },
    {
      pattern = "[a-z%-]+%s*()=%s*()%-?%d[%d%.]*",
      type = { "keyword", "operator", "number" }
    },
    -- Entities
    { pattern = "&#?[a-zA-Z0-9]+;",         type = "keyword2" },

  ---- Markdown rules
    -- math
    { pattern = { "%$%$", "%$%$", "\\"  },  type = "string", syntax = ".tex"},
    { pattern = { "%$", "%$", "\\" },       type = "string", syntax = ".tex"},
    -- code blocks
    { pattern = { "```c++", "```" },        type = "string", syntax = ".cpp" },
    -- ... there's some other patterns here, but I removed them for brevity
    { pattern = { "```lobster", "```" },    type = "string", syntax = ".lobster" },
    { pattern = { "```", "```" },           type = "string" },
    { pattern = { "``", "``" },             type = "string" },
    { pattern = { "%f[\\`]%`[%S]", "`" },   type = "string" },
    -- strike
    { pattern = { "~~", "~~" },             type = "keyword2" },
    -- highlight
    { pattern = { "==", "==" },             type = "literal" },
    -- lines
    { pattern = "^%-%-%-+\n",               type = "comment" },
    { pattern = "^%*%*%*+\n",               type = "comment" },
    { pattern = "^___+\n",                  type = "comment" },
    -- bold and italic
    { pattern = { "%*%*%*%S", "%*%*%*" },   type = "markdown_bold_italic" },
    { pattern = { "%*%*%S", "%*%*" },       type = "markdown_bold" },
    -- handle edge case where asterisk can be at end of line and not close
    {
      pattern = { "%f[\\%*]%*[%S]", "%*%f[^%*]" },
      type = "markdown_italic"
    },
    -- alternative bold italic formats
    { pattern = "^___[%s%p%w]+___%s" ,      type = "markdown_bold_italic" },
    { pattern = "^__[%s%p%w]+__%s" ,        type = "markdown_bold" },
    { pattern = "^_[%s%p%w]+_%s" ,          type = "markdown_italic" },
    -- heading with custom id
    {
      pattern = "^#+%s[%w%s%p]+(){()#[%w%-]+()}",
      type = { "keyword", "function", "string", "function" }
    },
    -- headings
    { pattern = "^#+%s.+\n",                type = "keyword" },
    -- superscript and subscript
    {
      pattern = "%^()%d+()%^",
      type = { "function", "number", "function" }
    },
    {
      pattern = "%~()%d+()%~",
      type = { "function", "number", "function" }
    },
    -- definitions
    { pattern = "^:%s.+",                   type = "function" },
    -- emoji
    { pattern = ":[a-zA-Z0-9_%-]+:",        type = "literal" },
    -- images and link
    {
      pattern = "!?%[!?%[()["..in_squares_match.."]+()%]%(()["..in_parenthesis_match.."]+()%)%]%(()["..in_parenthesis_match.."]+()%)",
      type = { "function", "string", "function", "number", "function", "number", "function" }
    },
    {
      pattern = "!?%[!?%[?()["..in_squares_match.."]+()%]?%]%(()["..in_parenthesis_match.."]+()%)",
      type = { "function", "string", "function", "number", "function" }
    },
    -- reference links
    {
      pattern = "%[()["..in_squares_match.."]+()%] *()%[()["..in_squares_match.."]+()%]",
      type = { "function", "string", "function", "function", "number", "function" }
    },
    {
      pattern = "!?%[%^?()["..in_squares_match.."]+()%]",
      type = { "function", "number", "function" }
    },
    -- url's and email
    {
      pattern = "<[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+%.[a-zA-Z0-9-.]+>",
      type = "function"
    },
    { pattern = "<https?://%S+>",           type = "function" },
    { pattern = "https?://%S+",             type = "function" },
    -- optimize consecutive dashes used in tables
    { pattern = "%-+",                      type = "normal" },
  },
  symbols = { },
}

-- Adjust the color on theme changes
core.add_thread(function()
  while true do
    if initial_color ~= style.syntax["keyword2"] then
      for _, attr in pairs({"bold", "italic", "bold_italic"}) do
        style.syntax["markdown_"..attr] = style.syntax["keyword2"]
      end
      initial_color = style.syntax["keyword2"]
    end
    coroutine.yield(1)
  end
end)
```

### Fuentes de sintaxis (Desde 1.16.10)

La sintaxis permite a los usuarios establecer diferentes estilos de fuente
(como negrita, cursiva y etc.) para diferentes patrones. Para cambiar el
estilo de fuente de un token, agrégale un Font a `style.syntax_fonts[tipo_de_token]`.
Por ejemplo:

```
-- se asegurará  de que todo token de tipo "fancysyntax_fancy_token" sea itálico
style.syntax_fonts["fancysyntax_fancy_token"] = renderer.font.load("myfont.ttf", 14 * SCALE, { italic = true })
```

El ejemplo de Markdown automatiza esto con un bucle for.

Las únicas limitaciones son que las fuentes no se pueden copiar con atributos distintos, lo que significa
que la ubicación de la fuente debe de ser codificada en el plugin. No solo eso, sino que abusar `style.syntax_fonts`
puede causar **bajo rendimiento** y **alto consumo de memoria**. Esto se vuelve muy obvio cuando el usuario trata
de cambiar el tamaño del editor usando `ctrl`+`scroll` o `ctrl`+`+` y `ctrl`+`-`. Por favor, usalo en moderación.

### Optimización de espacios (en v2.1 (pronto) / `master`)

Por defecto, Lite XL agrega el patrón `{ pattern = "%s+", type = "normal" }` a la sintaxis.
Esto mejora el rendimiento drasticamente en líneas que empiezan con espacios (p. ej. líneas muy sangradas)
haciendo coincidir los espacios antes que cualquier otro patron para prevenir que Lite XL itere
sobre la definición de sintaxis completa. Aún así, hay sintaxis que requieren marcar espacios
(p. ej. Markdown con bloques con sangría) así que esto se puede desactivar haciendo a `space_handling` falso.

> Para mantener la optimización de espacios, o para ser compatible con versiones antiguas de Lite XL,
> puedes añadir `{ pattern = "%s+", type = "normal" }` luego de los patrones que requieren espacios.

### Patrones simples con tokens múltiples (Desde 1.16.10)

Este es un extracto tomado del plugin de Markdown:

```lua
local in_squares_match = "^%[%]"
-- reference links
{
  pattern = "^%s*%[%^()["..in_squares_match.."]+()%]: ",
  type = { "function", "number", "function" }
},
```

A veces tiene sentido resaltar partes distintas de un patron de manera diferente.
Los parentesis vacíos (`()`) en patrones de Lua regresan la posición del texto en el parentesis.
Esto le dice a Lite XL cuando cambiar el tipo de token.
Por ejemplo,`^%s*%[%^` es `"function"`, `["..in_squares_match.."]+` es `"number"` y `%]: ` es `"function"`.

### Subsintaxis (Since v1.16.10)

Lite XL permite incrustar una sintaxis en la sintaxis existente.
Esto es usado para lograr resaltar bloques de codigo en la sintaxis de Markdown.

Por ejemplo:
```lua
{ pattern = { "```cpp", "```" },        type = "string", syntax = ".cpp" },
```

Esto resaltaría `` ```cpp `` and `` ``` `` con `"string"` mientras que todo lo demás dentro será resaltado
con una sintaxis que conincida con los archivos con extensión `".cpp"`.
