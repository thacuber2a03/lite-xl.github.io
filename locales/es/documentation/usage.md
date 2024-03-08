# Uso del editor

Lite XL es un editor de texto liviano escrito mayormente en Lua — su objetivo
es ser práctico, hermoso, *pequeño* y rapido, implementado de la manera
más simple posible; fácil de modificar y extender, o de usar sin hacer alguno.

Lite XL está basado en el editor de texto Lite y provee algunas mejoras
sin dejar de ser generalmente compatible con este.

## Cómo empezar

Lite XL funciona utilizando *un directorio como proyecto* — este es el directorio
en el cual reside el código de tu proyecto y otros datos.

Para abrir un proyecto específico, el nombre del directorio puede ser pasado
como argumento al programa *(`.` puede ser suplido para usar el directorio actual)*
o el directorio puede ser arrastrado hacia el ejecutable o hacia una instancia en ejecución.

Una vez abierto, el directorio del proyecto puede ser cambiado usando el comando
`core:change-project-folder`. El comando cerrará todos los documentos abiertos y
cambiará al nuevo directorio.

Si quieres abrir un directorio en una nueva ventana, el comando `core:open-project-folder`
abrirá una nueva ventana del editor con el directorio seleccionado.

La manera principal para abrir archivos en Lite XL es a través del comando `core:find-file`
— este proporciona un buscador difuso sobre todos los archivos del proyecto y puede ser
abierto a través del atajo de teclado `ctrl`+`p` por defecto.

Los comandos pueden ser ejecutados usando atajos de teclado, o usando el comando
`core:find-command`, conectado a `ctrl`+`shift`+`p` por defecto. Por ejemplo,
al presionar la combinación anterior, escribir `newdoc` y luego presionar `return`
se abrirá un nuevo documento. El atajo de teclado actualmente conectado a un comando
puede ser visto al lado del nombre del comando en el buscador de comandos, así que
para encontrar el atajo para un comando presiona `ctrl`+`shift`+`p` y escribe el
nombre del comando.

## Directorios de datos de usuario

Lite XL usa directorios de usuario de sistemas estándar; los datos del usuario pueden
ser encontrados en `$HOME/.config/lite-xl` en Linux y MacOS.
En Windows, la variable `$USERPROFILE` se usará en lugar de `$HOME`.

## Módulo del usuario

Lite XL puede ser configurado usando el módulo de usuario. El módulo de usuario se
puede utilizar para cambiar opciones en el módulo de configuación, añadir atajos
de teclado adicionales, cargar temas personalizados, modificar el estilo
o cambiar cualquier otra parte del editor a tu antojo.

El módulo de usuario se carga cuando se inicia la aplicación, luego de que los
plugins se han cargado.  El módulo de usuario puede ser modificado ejecutando
el comando `core:open-user-module` o abriendo el archivo `$HOME/.config/lite-xl/init.lua`
de otra manera.

En Windows, la variable `$USERPROFILE` se usará en lugar de `$HOME`.

**tl;dr:**

- Windows: `C:\Users\(nombre de usuario)\.config\lite-xl\init.lua`
- MacOS: `/Users/(nombre de usuario)/.config/lite-xl/init.lua`
- Linux: `/home/(nombre de usuario)/.config/lite-xl/init.lua`

Estas no son las ubicaciones exactas, pero te dan una idea de por donde empezar a buscar.

Ten en cuenta que la ubicación del módulo de usuario en Lite XL difiere de la ubicación del mismo archivo en Lite.

## Módulo del proyecto

El módulo del proyecto es un módulo opcional que se carga desde el directorio
del proyecto cuando se inicia Lite XL. Los módulos de proyecto pueden ser útiles
para cosas como añadir comandos personalizados para sistemas de compilación
específicos para el proyecto, o para cargar plugins específicos del proyecto.

El módulo del proyecto se carga cuando se inicia la aplicación,
luego de que los plugins y el módulo de proyecto se cargan.

El módulo del proyecto puede ser editado ejecutando el comando
`core:open-project-module` — se creará un módulo para el proyecto
actual si este no existe.

## Añadir directorios a un proyecto

Además de los directorios de proyecto es posible añadir otros directorios
usando el comando `core:add-directory`. Una vez añadido un directorio se mostrará
en el árbol de archivos a la izquierda y los archivos adicionales podrán ser
accedidos usando el atajo `ctrl`+`p` (encontrar archivo).
Los archivos adicionales también serán visibles al buscar a través del proyecto.

Los directorios adicionales pueden ser removidos usando el comando `core:remove-directory`.

Cuando abras Lite XL de nuevo en el mismo proyecto, la aplicación recordará tu
entorno de trabajo, incluyendo los directorios de proyecto adicionales.

Desde la version 1.15, Lite XL no necesita de un plugin de areas de trabajo,
ya que está incluido en el editor.

## Nuevo directorio vacío

Al usar el comando `files:create-directory` o presionar Ctrl y hacer click en un
directorio en el árbol de archivos, se creará un nuevo subdirectorio vacío en el
directorio seleccionado.

## Comandos

Los comandos son usados a través del buscador de comandos (`ctrl`+`shift`+`p`)
y a través del sistema de atajos de teclado de Lite XL. Los comandos consisten
de 3 componentes:

* **Nombre** — El nombre del comando en la forma `espacio-de-nombres:nombre-de-acción`.
  Por ejemplo: `doc:select-all`.
* **Predicado** — Una función que regresa `true` si el comando puede ser
  ejecutado. Por ejemplo, para todo comando que actúa sobre documentos, el predicado
  revisa si la vista activa es un documento.
* **Función** — La función que ejecuta el comando.

Puedes añadir comandos utilizando la función `command.add`, proveída por
el módulo `core.command`:

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

Los comandos se pueden ejecutar programaticamente (p. ej. desde otro comando
o por tu módulo de usuario) al llamar la función `command.perform`, una vez
requerido el módulo `command`:

```lua
local command = require "core.command"
command.perform "core:quit"
```

### Mapa de teclas

Todos los atajos de teclado son manejados por el módulo `core.keymap`.
Un atajo de teclado conecta una combinación de teclas (un "stroke", p. ej. `ctrl`+`q`)
a uno o más comandos (p. ej. `core:quit`). Cuando el atajo es presionado
Lite XL irá a través de cada comando asignado a ese atajo y evaluará la
*función de predicado* de ese comando — si el predicado pasa, ejecutará
el comando y dejará de iterar.

Un ejemplo de esta característica siendo usada es la conexión por defecto de la tecla `tab`:

``` lua
  ["tab"] = { "command:complete", "doc:indent" },
```

Cuando se presiona `tab` el comando `command:complete` se intenta ejecutar,
lo cual sólo sucederá si la entrada de comandos en la parte de abajo de la
ventana se encuentra activo. De otra manera se ejecutará el comando `doc:indent`,
lo cual también sólo se ejecutará si la vista activa es un documento.

Un nuevo atajo puede ser añadido en el módulo de usuario de esta manera:

```lua
local keymap = require "core.keymap"
keymap.add { ["ctrl+q"] = "core:quit" }
```

La lista de atajos por defecto puede ser vista [aquí][1].

### Variables globales

Hay algunas variables globales creadas por el editor.
Estas variables son accesibles en cualquier lugar y no deben de ser sobreescritas.

- `ARGS`: los argumentos de la linea de comandos. `argv[1]` es el nombre del programa, `argv[2]` es el primer argumento, ...
- `PLATFORM`: el valor que `SDL_GetPlatform()` regresa. Puede ser `Windows`, `Mac OS X`, `Linux`, `iOS` y `Android`.
- `SCALE`: la escala de la fuente. Usualmente es 1, pero puede ser mayor en sistemas HiDPI.
- `EXEFILE`: la ubicación absoluta del ejecutable.
- `EXEDIR`: el directorio del ejecutable. **NO GUARDES NADA EN ESTE DIRECTORIO.**
- `VERSION`: la version de Lite XL.
- `MOD_VERSION`: el `mod-version` usado en plugins. Esto usalmente se incrementa cuando hay cambios a la API.
- `PATHSEP`: el separador de ubicación. Es '\' en Windows y '/' en otros sistemas operativos.
- `DATADIR`: El directorio `data`, en el cual la parte escrita Lua del editor reside. **NO GUARDES NADA EN ESTE DIRECTORIO.**
- `USERDIR`: El directorio de configuración del usuario.

> Debe de usarse `USERDIR` en lugar de `DATADIR` al configurar el editor
> porque es posible que no se pueda escribir en `DATADIR`.
> (Por ejemplo, si el editor se instala en `/usr`, `DATADIR` será `/usr/share/lite-xl`!)
> Por otra parte, siempre se debe de poder escribir en `USERDIR`, ya que permite a múltiples usuarios
> personalizar su propio editor.

## Plugins

Los plugins en Lite XL son módulos de Lua normales y son tratados como tal —
no hay administrador de plugins complicado y, una vez cargado un plugin, no
se espera a que se descargue a sí mismo.

Para instalar un plugin, sólo dejalo en el subdirectorio `plugins` del directorio de usuario.
Cuando Lite XL inicie, primero cargará los plugins en el directorio `data` y luego cargará
los plugins en el directorio de usuario.

Para desinstalar un plugin, borra el archivo del plugin — todo plugin
(incluyendo aquellos incluidos por defecto con la instalación) puede ser borrado
para remover su funcionalidad.

Si solo quieres cargar un plugin bajo ciertas circumstancias (por ejemplo,
sólo en un proyecto específico) el plugin puede ser puesto en otro lugar que
no sea el directorio `plugins` para que no se cargue automaticamente. El
plugin puede luego ser cargado manualmente cuando se requiera usando la
función `require`.

Puedes descargar plugins desde el [repositorio de plugins][2].

## Reiniciar el editor

Si modificas el archivo de configuración o alguno de los archivos de implementación de Lua
puedes reiniciar el editor usando el comando `core:restart`.
La aplicación entera se reiniciará manteniendo la ventana ya abierta.

## Temas

Los temas en Lite XL son módulos de Lua que sobreescriben los campos de color
del módulo `core.style` del editor.
Los temas por defecto están ubicados en el directorio `colors` del directorio de datos.
Otros temas pueden ser instalados en el directorio de usuario, en el subdirectorio `colors`.

Puedes aplicar un tema requiriendolo en tu módulo de usuario:

```lua
core.reload_module "colors.winter"
```

En el editor Lite se usa la función `require` en vez de `core.reload_module`.
En Lite XL, `core:reload_module` debe de usarse para asegurar que el módulo
se recargue al guardar el archivo de configuración del usuario.

Puedes descargar temas en el [repositorio de temas][3].
Están todos incluidos con cada lanzamiento de Lite XL.

[1]: /es/documentation/keymap
[2]: https://github.com/lite-xl/lite-xl-plugins
[3]: https://github.com/lite-xl/lite-xl-colors
