# Compilación

Una vez que hayas descargado el código fuente, puedes compilar Lite XL usando Meson.
Además, el script `build-packages.sh` puede ser usado para compilar el editor y
crear un ejecutable especifico para Linux, Windows o MacOS.

Se requieren las siguientes librerías:

- freetype2
- SDL2

Las siguientes librerías son **opcionales**:

- libagg
- Lua 5.2

Si no se encuentran, serán descargadas y compiladas por Meson.
Si están presentes, se usarán para compilar el editor.

## Script de compilado

Si decides compilar Lite XL, se recomienda utilizar el script `build-packages.sh`:

```bash
bash build-packages.sh -h
```

El script correrá Meson y creará un archivo comprimido de formato `.tar` con la aplicación, o,
para Windows, un archivo `.zip`. Lite XL puede ser instalado fácilmente descomprimiendo el archivo
en cualquier directorio de tu elección.

En Windows se crearán dos archivos, uno llamado "portable" usando el folder "data"
junto al ejecutable y el otro usando un formato de archivo similar al de Unix.
Ambos paquetes funcionan correctamente. El que tiene el formato estilo Unix es
para personas usando una shell estilo Unix y/o la linea de comandos.

Nota que no hay directorios específicos programados en el ejecutable,
para que el paquete pueda extraerse y usarse en cualquier directorio.

## Portable

Al ejecutar `meson setup` puedes añadir la opción `-Dportable=true` para especificar
cuáles archivos deben de ser instalados en una aplicación portable.

Si `portable` está activado, Lite XL se compila para usar un directorio llamado
`data`, puesto al lado del ejecutable.
De otra manera, Lite XL usará ubicaciones estilo Unix. En este caso, el directorio
`data` estará en `$prefix/share/lite-xl` y el ejecutable estará en `$prefix/bin`.
La variable `$prefix` se determina cuando la aplicación se ejecuta, de tal manera
que `$prefix/bin` corresponde a la ubicación del ejecutable.

El directorio `user` no depende de la opción `portable` y siempre será `$HOME/.config/lite-xl`.
`$HOME` se determina a partir de la variable de entorno correspondiente.
Como caso especial, en Windows se usará la variable `$USERPROFILE`.

## Linux

En sistemas basados en Debian las librerías requeridas y Meson pueden ser
instaladas usando los siguentes comandos:

```bash
# Para instalar las librerías requeridas:
sudo apt install libfreetype6-dev libsdl2-dev

# Para instalar Meson:
sudo apt install meson
# o pip3 install --user meson
```

Para compilar Lite XL con Meson los comandos siguientes pueden ser usados:

```bash
meson setup --buildtype=release --prefix <prefix> build
meson compile -C build
DESTDIR="$(pwd)/lite-xl" meson install --skip-subprojects -C build
```

...en donde `<prefix>` depende del sistema operativo que estás usando:
- en Linux es `/usr`
- en el paquete de aplicaciones de MacOS puede ser `"/Lite XL.app"`

Si usas una version de Meson menor que 0.54 tienes que usar
comandos diferentes para compilar e instalar:

```bash
meson setup --buildtype=release build
ninja -C build
ninja -C build install
```

## macOS

macOS está completamente soportado y una imagen de disco certificada
se encuentra en la [página de lanzamientos][1].
La aplicación también puede ser compilada usando las instrucciones genéricas
proporcionadas anteriormente.

## Windows MSYS2

El entorno de compilación escogido para Lite XL en Windows es [MSYS2][2].
Sigue las instrucciones de instalación en el enlace.

- Abre la shell de `MinGW 64-bit` o `MinGW 32-bit` del menú start.
- Actualiza la instalación de MSYS2 con el comando `pacman -Syu`.
- Reinicia la shell.
- Instala las dependencias:

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

`${MINGW_PACKAGE_PREFIX}` expande a `mingw-w64-i686` o a `mingw-w64-x86_64`,
dependiendo de si la shell es de 32 o 64 bits.

[1]: https://github.com/lite-xl/lite-xl/releases/latest/
[2]: https://www.msys2.org/
