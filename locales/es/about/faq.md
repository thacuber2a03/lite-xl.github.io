# FAQ

#### Puedo tener autocompletación intelligente (intellisense/LSP)?

Consigue el plugin [LSP].

#### Donde está la terminal integrada?

Prueba [lite-xl-terminal].

#### Y qué hay de los tabs y el tamaño de la indentación?

Escribe en tu configuración de usuario (el icono de engranaje en el árbol de archivos):

```lua
config.tab_type = "soft" -- 'soft' para usar espacios, 'hard' para tabs reales (\t)
config.indent_size = 4   -- 4 espacios
```

#### Cómo conecto commandos a ciertas teclas?

```lua
local keymap = require "core.keymap"
keymap.add { ["ctrl+escape"] = "core:quit" }
```

#### Cómo *desconecto* commandos de ciertas teclas?

```lua
-- el segundo argumento te permite sobreescribir los comandos de ciertas teclas
-- en este caso, se conecta a nada
keymap.add({ ["ctrl+escape"] = {} }, true)
```

#### Cómo consigo los comandos conectados a esas teclas?

Puedes buscar comandos en la paleta de comandos.

Para cada comando, reemplaza los espacios del comando con guiones.

Por ejemplo: `Core: Find Command` → `core:find-command`

#### Qué versión de Lua usa el editor?

Lua 5.4.

#### Algún modo que emule a Vim?

Consigue [vibe].

#### Recomendaciones de plugins?

En caso de que no quieras revisar nuestro [repositorio de plugins][1],
esta es una lista de plugins que hacen a Lite XL más agradable.

| Plugin               | Uso del plugin
| ---                  | ---
| [autoinsert]         | Automáticamente inserta brackets y comillas de cierre.
| [bracketmatch]       | Resalta pares de brackets.
| [ephemeral_tabs]     | Pestañas efímeras (para revisar archivos sin abrir muchas pestañas).
| [gitdiff_highlight]  | Marcador de git diff.
| [lint+]              | Soporte para linters.
| [minimap]            | Un minimapa.
| [selectionhighlight] | Resalta código que sea igual a la selección.
| [lite-xl-discord]    | Discord RPC.

#### Donde está tal herramienta? Qué hay de X funcionalidad?

Puedes tener más información en la [página de características](/es/about/features).


[LSP]:                https://github.com/lite-xl/lite-xl-lsp
[lite-xl-terminal]:   https://github.com/adamharrison/lite-xl-terminal
[vibe]:               https://github.com/eugenpt/lite-xl-vibe
[autoinsert]:         https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/autoinsert.lua?raw=1
[bracketmatch]:       https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/bracketmatch.lua?raw=1
[ephemeral_tabs]:     https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/ephemeral_tabs.lua?raw=1
[gitdiff_highlight]:  https://github.com/vincens2005/lite-xl-gitdiff-highlight
[lint+]:              https://github.com/liquid600pgm/lintplus
[minimap]:            https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/minimap.lua?raw=1
[selectionhighlight]: https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/selectionhighlight.lua?raw=1
[lite-xl-discord]:    https://github.com/vincens2005/lite-xl-discord

[1]: https://github.com/lite-xl/lite-xl-plugins
