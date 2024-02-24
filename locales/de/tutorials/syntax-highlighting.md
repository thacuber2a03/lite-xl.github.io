<!-- Delete later: continue at line 161 -->

# Syntaxhervorhebung

## So erstellt man Syntaxhervorhebung für Lite XL
Syntaxhervorhebung Plugins für Lite XL sind Lua Dateien. Diese Dateien definieren Muster oder Regex
verschiedene teile einer gegebenen Sprache, man ordnet Token-Typen zu Übereinstimmung zu.
Diese verschiedenen Token-Typen werden dann verschiedene farben von deinem ausgesuchten Color Scheme gegeben.

Wie andere Plugins, Syntax Definitionen werden von den folgenden Ordnern empfangen, in der folgenden Reihenfolge:

- `/usr/share/lite-xl/plugins/`
- `$HOME/.config/lite-xl/plugins/`

BEMERKE: Der genaue Ort von diesen Ordnern wird von dein Betriebssystem und Installationsmethode abhängen. Zum Beispiel, unter Windows wird das Variable `$USERPROFILE` benutzt werden anstatt `$HOME`.

Der Benutzer Modul Ordner für Lite Xl kann in diesen Orten auf different Betriebssystemen gefunden werden:

- Windows: `C:\Users\(nutzername)\.config\lite-xl`
- MacOS: `/Users/(nutzername)/.config/lite-xl`
- Linux: `/home/(nutzername)/.config/lite-xl`

Also, um eine neue Syntax Definition auf Linux zu erstellen, musst du eine `.lua` Datei in dein `$HOME/.config/lite-xl/plugins/` Ordner machen.

## Welche Syntax-Token arten sind unterstützt?

Die unterstützten Syntax_Token art, definiert von `lite-xl/core/style.lua`, sind:

- normal
- symbol
- comment
- keyword
- keyword2
- number
- literal
- string
- operator
- function

In dein Syntaxhervorhebung Plugin, schreibst du Muster um Teile der Sprachen-Syntax zu entsprechen, und um Token-Typen zu übereinstimmen. Du musst nicht alle benutzen - benutze so viele die du brauchst für deine Sprache.

Let's walk through an example syntax definition and see how this works.

Gehen wir mal durch eine Beispiel Syntax Definition und wir werden sehen wie es funktioniert.

## Beispiel Syntax: ssh config Dateien

Das ist ein kleines, simples Beispiel von einer Syntax Definition, Es soll eine SSH config Datei hervorheben und es sieht so aus:

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
    -- ssh config
    ["Host"]                         = "function",
    ["ProxyCommand"]                 = "function",

    ["HostName"]                     = "keyword",
    ["IdentityFile"]                 = "keyword",
    ...

    -- sshd config
    ["Subsystem"]                    = "keyword2",

    -- Literals
    ["yes"]      = "literal",
    ["no"]       = "literal",
    ["any"]      = "literal",
    ["ask"]      = "literal",
  },
}
```

Schauen wir uns mal jeden Teil an und schauen wie es funktioniert.

### Header

Die erste Zeile ist ein Lua kommentar und sagt Lite XL welche version dieses Plugin braucht. Die zweite Zeile importiert das `core.syntax` Modul
dass wir nutzen können:

```lua
-- mod-version:2 -- lite-xl 2.0
local syntax = require "core.syntax"
```

Dann fügen wir eine Syntax Definition mit `syntax.add {...}` zu lite ein.

#### Files

Die `files` Eigenschaft sagt Lite XL welche Dateien these Syntax benutzt werden soll. Das ist ein Lua Muster, das mit dem vollständigen Pfad der geöffneten Datei übereinstimmt. Zum Beispiel, um gegen Markdown Dateien zu übereinstimmen - mit entweder eine `.md` oder eine `.markdown` Erweiterung,
du könntest das machen:

```lua
files = { "%.md$", "%.markdown$" },
```

In unseren original Beispiel, gleichen wir mit dem Ende des Pfads und nicht mit der Erweiterung ab, weil SSH config Dateien keine Erweiterung hat - und wir nicht alle `config` Dateien abgleichen. Wir erwarten den Pfad für SSH config Dateien so auszusehen:

- `~/.ssh/config`
- `/etc/ssh/ssh_config`
- `/etc/ssh/sshd_config`

Dieses Muster gleicht Pfade ab die so aussehen:

```lua
files = { "sshd?/?_?config$" },
```

### Kommentare

Die Kommentar Eigenschaft definiert _nicht_ welche Teile der Syntax Kommentare sind - Schaue auf Muster für das unten. Diese Eigenschaft sagt Lite XL welche Charaktere beim Anfang der ausgewählten Zeilen hinzufügt werden sollen, wenn du `ctrl+/` drückst.
Du kannst auch `block_comment` benutzen um Lite XL zu sagen, wie es multiline oder Block Kommentare machen soll.

### Muster

Ein gegebener Textabschnitt kann nur ein Muster abgleicht werden. Wenn Lite XL einmal einschieden hat, dass es mit einem Muster übereinstimmt, dann wird es den Token-Typen zuweisen und es wird weitergehen.
Muster werden getestet in der Reihenfolge wie es in der Syntax Definition geschrieben wurde, also wird das erste Übereinstimmen gewinnen.

Jedes Muster nimmt einer dieser Formen an:

#### Einfaches Muster

```lua
{ pattern = "#.*\n",        type = "comment" },
```

Diese Form gleicht die Zeile mit dem Muster ab und wenn es abstimmt, weist es in diesem Fall den passenden Text den gebenen Token `type` - `comment` zu.

#### Start- & Endmuster

```lua
{ pattern = { "%[", "%]" }, type = "keyword" },
```

Diese Form hat zwei Muster - eines das mit dem Anfang des Bereichs übereinstimmt und eines dass mit dem Ende übereinstimmt. Alles zwischen den Anfang und den Ende wird den Token `type` zugewiesen.

#### Start- & Endmuster, mit Ausgang

```lua
{ pattern = { '"', '"', '\\' }, type = "string" },
```

Dieses ist das Gleiche wie die letzte Form, aber mit einem dritten Parameter.
Der dritte Teil, der `'\\'` Teil in diesem Beispiel, spezifiziert den Charakter dass entkommen vom Schlussübereinstimmung ermöglicht.

Für mehr Information von Lua Muster, sehe [Lua Muster Referenz (English)](https://www.lua.org/manual/5.3/manual.html#6.4.1)

Wenn du PCRE Regular Expressions anstatt Lua Muster benutzen musst, kannst du das Stichwort `regex` anstelle von `pattern` benutzen.

### Symbole

> Dieser Teil ist **nicht mit dem `symbol` Token-Typ verwandt**.

Dieser Symbol Teil erlaubt dir Token-Typen zu bestimmten Schlüsselwörtern zuzuordnen - normalerweise sind das Wörter in der Sprache dass du hervorhebst.
Der Token-Typ in diesem Teil nimmt immer Vorrang über Token-Typen deklariert im Muster.

Zum Beispiel, Dieses Code markiert `Host` als `function` Token-Typ, `HostName` als `keyword` und `yes`, `no`, `any` & `ask` als `literal`:

```lua
["Host"]                         = "function",
["HostName"]                     = "keyword",

["yes"]      = "literal",
["no"]       = "literal",
["any"]      = "literal",
["ask"]      = "literal",
```

#### Tips: Überprüfe deine Muster!

Es gibt häufige Fehler die gemacht werden können wenn man das `symbols` Table in Verbindung mit Muster benutzt.

##### Fall 1: Leerzeichen zwischen zwei `symbols` Token:

Nehmen wir mal ein Beispiel:

```lua
{ pattern = "[%a_][%w_]+%s+()[%a_][%w_]+", type = { "keyword2", "symbol" } }
```

Jetzt erklären wir mal das Muster ein bisschen (Lasse die Leeren Klammer weg):

```
[%a_] = alle Buchstaben und Unterstriche
[%w_] = alle Buchstaben, Nummern und Unterstriche
%s = alle Leerzeichen Charaktere

WORD =
  [%a_] gefolgt von (1 oder mehr [%w_])

pattern =
  WORD, gefolgt von (einem oder mehreren %s), gefolgt von WORD
```

Nachher fügst du einen Eintrag `["my"] = "literal"` im `symbols` Table.
Du kannst die Syntax testen mit `my function`, und findest heraus das `"my"` nicht als `literal` markiert wurde. Warum ist das passiert?

**`symbols` table braucht eine genaue Übereinstimmung**.
Wenn du sorgfältig schaust, siehst du dass leere Klammern **nach dem Leerzeichen** platziert wurden!
Dass sagt Lite XL dass `[%a_] gefolgt von (1 oder mehr [%w_])` ein Token ist, dass `my ` übereinstimmen soll (bemerke das Leerzeichen in der Übereinstimmung).

Das Lösung steckt darin, ein `normal` Token für Leerzeichen zwischen zwei Tokens hinzuzufügen:

```lua
{ pattern = "[%a_][%w_]+()%s+()[%a_][%w_]+", type = { "keyword2", "normal", "symbol" } }
```

##### Fall 2: Muster & `symbols` Token

Man könnte annehmen dass Lite XL magisch Text mit den `symbols` Table vergleicht. Dies ist nicht der Fall.

In manchen Sprachen fügen Leute generische Muster hinzu, um den Abgleich an die Tabelle `symbols` zu delegieren.

```lua
{ pattern = "[%a_][%w_]*", "symbol" }
```

Jedoch könnte das `symbols` Table so ausschauen:

```lua
symbols = {
  ["my-symbol"] = "function",
  ["..something_else"] = "literal"
}
```

`my-symbol` enthält ein Strich (`-`) und `"..something_else"` enthält zwei Punkte (`.`).
Keinen von diesen Charakteren stimmt mit `[%a_][%w_]*` überein!

**Vorsicht vor dem Text den du im `symbols` Table übereinstimmen willst.**
**Wenn du es benutzen willst, musst du dir sicher sein, dass es mit einer dieser Muster übereinstimmt.**

Die richtigen Muster sind:

```lua
{ pattern = "[%a_][%w%-_]*", "symbol" },
{ pattern = "%.%.[%a_][%w_]*", "symbol" },
```

## Deine neue Syntax testen

Um deine neue Syntaxhervorhebung zu testen musst du diesen zwei Dinge machen:

- Lade den Lite XL Core neu
- Lade eine Datei deiner ausgewählten Sprache und schaue an wie es ausschaut

Um den Core neuzuladen kannst du entweder Lite XL neustarten, oder du ladest den Core über das Befehlspalette neu.
Um dies zu machen, drücke `ctrl+shit+` Befehlspalette zu zeigen, dann wähle `Core: Restart` aus (oder schreibe `crr` oder ähnliches um es zu finden), dann drücke Enter. Du musst den Core immer neustarten wenn du änderungen zur Syntaxhervorhebung machst.


## Beispiel des fortschrittlichen Syntax: Markdown

> **Bemerke: Dieses Beispiel hat Funktionen von 2.1. Es ist nicht kompatible mit älteren Versionen von lite-xl**

Nicht alle Sprachen sind so leicht wie SSH config Dateien. Markup Sprache wie HTML und Markdown sind sehr schwer richtig zu analysieren. Hier ist die Markdown Syntaxhervorhebung Datei in seiner vollen Pracht:

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

### Syntaxschriftarten (Seit 1.16.10)

Die Syntax erlaubt Benutzer verschiedene Schriftarten Stile (Bold, Italic, usw.) für verschiedene Muster zu setzen.
Um ein Schriftarten Stil von ein Token zu ändern, füge eine Schriftarten bei `style.syntax_fonts[token_type]` hinzu.
Zum Beispiel:
```
-- Wird sorgen, dass jedes "fancysyntax_fancy_token" Italic sein wird.
style.syntax_fonts["fancysyntax_fancy_token"] = renderer.font.load("myfont.ttf", 14 * SCALE, { italic = true })
```

Das Markdown Beispiele automatisiert dies mit einem for loop.

Die Limitationen hier sind dass Schriftarten nicht von anderen Attributen kopiert werden können, also müssen Schriftartenpfade fest codiert werden.
Der Missbrauch von `style.syntax_fonts` kann zur **langsame Leistung** und einen **hohen Speicherverbrauch** führen.
Dies ist bemerkbar wenn ein Benutzer versucht die Größe des Editors mit `ctrl-scroll` or `ctrl+` and `ctrl-` zu ändern.
Bitte benutze es in Moderation.

### Leerzeichen Umgang (v2.1 (Bevorstehend) / `master`)

Normalerweise stellt Lite XL das Muster `{ pattern = "%s+", type = "normal" }` zu der Syntaxhervorhebung.
Dies verbessert die Leistung drastisch bei Zeilen die mit Leerzeichen (z.B schwer-eingerücke Zeilen)
Durchs anpassen des Leerzeichens bevor andere Muster muss Lite XL nicht durch die ganze Syntax durchgehen.
Jedoch gibt es Syntaxen die Leerzeichen anpassen müssen (z.B Markdown mit einrückten Codeblocken)
Also kann dies deaktiviert werden indem man `space_handling` to `false.` stellt.

> Um die Leerzeichen Umgang Optimisierung zu behalten, oder um ältere Versionen von Lite XL zu unterstützen kann
> `{ pattern = "%s+", type = "normal" }` nach Muster, die Leerzeichen brauchen hinzugefügt werden.

### Einfache Muster mit mehrere Tokens (1.16.10)

Dies ist ein Ausschnitt dass von der Markdown Syntaxhervorhebung genommen wurde:

```lua
local in_squares_match = "^%[%]"
-- reference links
{
  pattern = "^%s*%[%^()["..in_squares_match.."]+()%]: ",
  type = { "function", "number", "function" }
},
```

Manchmal macht es Sinn verschiedene Teile eines Musters anderst zu hervorheben.
Leere Klammer (`()`) in Lua Muster werden die Position vom Text in den Klammern zurückgeben.
Dies wird Lite XL sagen, wenn es den Typ des Tokens ändern muss.
Zum Beispiel, `^%s*%[%^` ist `"function"`, `["..in_squares_match.."]+` ist `"number"` und `%]: ` ist `"function"`.

### Subsyntaxen (Seit 1.16.10)

Lite XL unterschützt Einbettung von anderen Syntaxen in einer existierenden Syntax.
Dies kann benutzt werden, um Codeblöcke im Markdown Syntax zu Unterstützen.

Zum Beispiel:
```lua
{ pattern = { "```cpp", "```" },        type = "string", syntax = ".cpp" },
```

Dies würde `` ```cpp `` und `` ``` `` mit `"string"` markieren während alles innerhalb mit der Syntax dass mit `".cpp"` übereinstimmt markiert wird.
