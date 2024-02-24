# Downloads

## Binary Packete

Binär Packete sind verfügbar in der [GitHub Veröffentlichungensseite][1].

## Installieren über Packetverwaltung

Oder du kannst Lite-XL über den Paketmanager deiner Distribution installieren.
**Diese Packete werden von der Community erhalten und sind vielleicht veraltet.**

- [Windows][2] ([Chocolatey][3] / [Scoop][4])
- [Mac OS][5] (MacPorts)
- [Arch Linux][6] (AUR)
- [NixOS][7] (nixpkgs)
- [Fedora][8]

```sh
choco install lite-xl                                        # chocolatey
scoop bucket add extras && scoop install lite-xl             # scoop
sudo port install lite-xl                                    # macports
yay -S lite-xl                                               # oder dein lieblings AUR helper
nix-env -i lite-xl                                           # nixos
sudo dnf install lite-xl # fedora
```

## Quellcode

Das Quellcode ist verfügbar auf [GitHub][9], durch Herunterladen von Zip- oder Tar Archiven,
oder direkt über Git:

```sh
git clone https://github.com/lite-xl/lite-xl.git
```


[1]: https://github.com/lite-xl/lite-xl/releases/latest
[2]: https://github.com/microsoft/winget-cli/discussions/223#discussion-15735
[3]: https://community.chocolatey.org/packages/lite-xl
[4]: https://github.com/ScoopInstaller/Extras/blob/master/bucket/lite-xl.json
[5]: https://ports.macports.org/port/lite-xl/
[6]: https://aur.archlinux.org/packages/lite-xl/
[7]: https://github.com/NixOS/nixpkgs/blob/release-21.11/pkgs/applications/editors/lite-xl/default.nix
[8]: https://src.fedoraproject.org/rpms/lite-xl
[9]: https://github.com/lite-xl/lite-xl
