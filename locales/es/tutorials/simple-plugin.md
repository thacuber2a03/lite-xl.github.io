# Plugin "Simple"

### ¿Qué es Simple?
Simple es un plugin muy básico, escrito con la intención de introducir
a nuevos desarrolladores de Lite XL al proceso de escritura de plugins para el editor.

### ¿Qué hace el plugin?
El plugin muestra un mensaje (tomado como entrada del usuario) en
la esquina superior derecha de la ventana del editor. También le permite
al usuario alternar la visibilidad del mensaje.

### ¡No sé escribir en Lua!
Si vienes de otros lenguages de programación, lee este [cheatsheet de Lua][1].
Si eres nuevo programando, puedes leer [esto][2].

### Formato del tutorial
El código contiene elementos detallando que es lo que la mayor parte, si no todo el código en el archivo hace.


### El código:
```lua
-- mod-version:3

-- TIENES que escribir mod-version:x en la primera línea del plugin.
-- mod-version usualmente equivale al componente mayor de
-- la versión de los lanzamientos de Lite XL (p. ej. mod-version: 2 == lite-xl 2.0).
-- Lite XL no va a cargar el archivo si el mod-version no es igual

-----------------------------------------------------------------------
-- NAME       : Simple
-- DESCRIPTION: Una simple guía acerca de cómo hacer tu primer plugin de Lite XL
-- AUTHOR     : Ashwin Godbole (aelobdog)
-- GOALS      : Dibujar texto en la pantalla
-----------------------------------------------------------------------
-- Disclaimer :
-- No soy un desarrollador de Lua, y mi conocimiento acerca de escribir plugins para
-- Lite XL es muy limitado. Este archivo sirve el propósito de ayudar al
-- lector a empezar con el desarrollo de plugins para Lite XL, y por tal motivo
-- solo demuestra algunas funciones básicas. Para desarrollo de plugins más complejo,
-- asegúrate de revisar el código fuente de otros plugins luego de leer este archivo.
-----------------------------------------------------------------------
-- Antes de empezar a escribir código para el plugin, tenemos que importar los
-- módulos requeridos desde el paquete "core".

-- el módulo "core"
local core = require "core"

-- el módulo "command" nos ayudará registrar comandos para nuestro plugin.
local command = require "core.command"

-- el módulo "style" nos permitirá usar opciones de estilizado
local style = require "core.style"

-- el módulo "config" será usado para guardar ciertas cosas
-- como colores y funciones
local config = require "core.config"

-- el módulo "keymap" nos permitirá conectar combinaciones de teclas a nuestros comandos
local keymap = require "core.keymap"

-- como queremos modificar RootView, primero lo tenemos que requerir
local RootView = require "core.rootview"

-----------------------------------------------------------------------
-- la configuración de cada plugin tiene que estar en config.plugins.(nombre de plugin)
config.plugins.simple = {}

-- Los colores son solo tres o cuatro valores separados por comas (RGBA) (rango 0 - 255)
-- puestos dentro de '{ }'. Añadiremos nuestro color al módulo de configuración.
config.plugins.simple.text_color = {200, 140, 220} -- o usa `{ common.color "#C88CDC" }`
-----------------------------------------------------------------------
-- Vamos a crear una función para calcular las coordenadas de nuestro texto.
-- Mientras tanto, le añadiremos nuestras funciónes al módulo `config`.
-- Tomaremos el mensaje que queremos mostrar como argumento a la función
-- para determinar las coordenadas x e y del texto.

function config.plugins.simple.get_text_coordinates(message)
   -- Para este plugin, queremos mostrar el texto en la esquina superior izquierda
   -- de la pantalla. Para esto, tenemos que saber el ancho y alto del editor.

   -- El tamaño de la fuente actual puede ser obtenido del módulo "style".
   -- Las dimensiones del editor pueden ser obtenidos usando:
   --   1. ANCHO : core.root_view.size.x
   --   2. ALTO  : core.root_view.size.y

   local message_width = style.code_font:get_width(message.." ")
   local font_height = style.code_font:get_size()
   local x = core.root_view.size.x - message_width
   local y = font_height / 2

   return x, y
end
-----------------------------------------------------------------------
-- Ahora vamos a realmente dibujar el texto dentro del editor.
-- Para "inyectar" nuestro código para dibujar texto,
-- tenemos que guardar la función de dibujo original.
-- Guardaremos `RootView.draw` a una variable que llamaremos `parent_draw`.

local parent_draw = RootView.draw

-- Ahora sobrecarguemos la definición original de `draw` en RootView
-- redefiniendo la función.

function RootView:draw()
   -- Llamamos a la función padre para mantener al editor funcional...
   -- aún tenemos que dibujar todo lo demás!
   -- Así que llamamos a `parent_draw` antes de hacer cualquier otra cosa.
   parent_draw(self)

   -- Añadiremos una opción para alternar el mensaje. Usemos un
   -- boolean para saber si queremos mostrar el mensaje o no.
   if config.plugins.simple.show_my_message then
      -- Tomaremos el mensaje para mostrar como entrada del usuario más tarde.
      -- Guardaremos esa entrada en `config.plugins.simple.hw_message`.
      -- (NOTA: esta variable no viene integrada en lite-xl;
      --        es una variable que definiremos luego.)

      -- Guardemos el valor de `config.plugins.simple.hw_message` en una variable local booleana
      -- `message` en caso de que le hayamos puesto a `config.plugins.simple.hw_message`
      -- el mensaje "¡aún no hay mensaje!"
      local message

      if config.plugins.simple.hw_message then
          message = config.plugins.simple.hw_message
      else
          message = "¡aún no hay mensaje!"
      end

      -- Consigamos las coordenadas para nuestro texto.
      local x, y = config.plugins.simple.get_text_coordinates(message)

      -- Finalmente, dibujemos el texto a la pantalla!
      -- La función `draw_text` de `renderer` es una función importante
      -- ya que se usa para mostrar todo el texto dentro de la pantalla del editor.
      renderer.draw_text(style.code_font, message, x, y, config.plugins.simple.text_color)
   end
end
-----------------------------------------------------------------------
-- Permitamosle al usuario encender o apagar el mensaje.
-- Escribiremos una función que alternará nuestra variable booleana "show".

local function toggle_helloworld()
   config.plugins.simple.show_my_message = not config.plugins.simple.show_my_message
end
-----------------------------------------------------------------------
-- Finalmente, vamos a añadir la función de alternación a la lista de commandos, para que así
-- la podamos llamar desde el panel de comandos C-S-p (el buscador de comandos). Vamos a agregar un comando
-- para alternar la visibilidad del mensaje y uno para conseguir el mensaje del usuario y mostrarlo.

command.add(nil, {
   -- Alternar la visibilidad del mensaje
   ["simple:toggle"] = toggle_helloworld,

   -- Establecer y mostrar el mensaje
   -- Esta es una buena manera de tomar entrada del usuario a través de la barra de comandos.
   -- `core.command_view:enter` toma 2 argumentos:
   --    * el mensaje que se va a mostrar antes de recibir entrada
   --    * una función que toma la entrada como argumento
   -- (NOTA: aquí la variable en la que estamos leyendo la entrada es `text`)

   -- (nota del traductor: cuando se escribió este tutorial, esta era
   -- la manera de hacerlo, pero ahora tienes que pasar una tabla con
   -- un campo para cada función de la barra de comandos)
   ["simple:setshow"] = function()
      core.command_view:enter("Test to display", {
         submit = function(text)
            config.plugins.simple.hw_message = text
            config.plugins.simple.show_my_message = true
         end
      })
   end
})
-----------------------------------------------------------------------
-- Sólo por diversion, asignemos nuestos comandos sus propios atajos.
-- Aqui, le asignamos a los atajos el mismo string (el nombre) que les pusimos
-- a los comandos cuando los creamos.
keymap.add {
   ["alt+s"] = "simple:setshow",
   ["alt+t"] = "simple:toggle",
}
```

### Lecturas adicionales
- [Lite: An Implementation Overview][3], un post excelente por rxi que sigue siendo parcialmente relevante para Lite XL.
- [Descripción general del API][4], donde se explican algunas de las funciones del API.

[1]: https://devhints.io/lua
[2]: https://www.lua.org/pil
[3]: https://rxi.github.io/lite_an_implementation_overview.html
[4]: /es/tutorials/api-overview
