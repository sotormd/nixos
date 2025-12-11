# NixOS Configuration Flake

~~slighly overengineered~~ NixOS configuration flake for multiple hosts.

![nixos](./docs/screenshots/nixos.gif)

Nix-specific features:

- completely reproducible, pure evaluation
- dotfiles managed using wrappers implemented from basic nixpkgs functions
- symlinks in ~ managed using [hjem](https://github.com/feel-co/hjem)
- secrets managed using [sops-nix](https://github.com/Mic92/sops-nix)
- secure boot using [lanzaboote](https://github.com/nix-community/lanzaboote)
- impermanence using zfs snapshots and bind mounts
- package management using [lix](https://lix.systems)
- android environment using
  [nix-on-droid](https://github.com/nix-community/nix-on-droid)
- nixos flake helper [cli](#nixos-flake-helper)
- flake enabled [images](#images)

See [Features](#features) for all features.

# Contents

1. [Setup & Usage](#setup--usage)
2. [Images](#images)
3. [nixos: Flake Helper](#nixos-flake-helper)
4. [Features](#features)

# Setup & Usage

1. `laptop` role: Laptop configuration

   [Setup & Usage Documentation](./docs/laptop.md)

2. `server` role: Headless home server configuration

   [Setup & Usage Documentation](./docs/server.md)

3. `droid` role: nix-on-droid configuration

   [Setup & Usage Documentation](./docs/droid.md)

# Images

[![Build Minimal ISO](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml/badge.svg)](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml)
[![Build GNOME ISO](https://github.com/sotormd/nixos/actions/workflows/build-gnome-iso.yml/badge.svg)](https://github.com/sotormd/nixos/actions/workflows/build-gnome-iso.yml)
[![Build SD Image](https://github.com/sotormd/nixos/actions/workflows/build-sdcard-image.yml/badge.svg)](https://github.com/sotormd/nixos/actions/workflows/build-sdcard-image.yml)

Three images: `minimal`, `gnome` and `sdcard` are included (for installation,
recovery, etc.)

These images have experimental features `flakes` and `nix-command` enabled.

See [images](./docs/images.md) for more details.

# `nixos` Flake Helper

Routine tasks such as updating the flake, switching configurations,
garbage-collecting, repairing the Nix store, and editing variables & secrets are
handled through the unified `nixos` helper script.

To see all commands:

```bash
nixos help
```

See [scripts](./docs/scripts.md) for the full command reference and workflow
examples.

# Features

|                               |                                                          |
| ----------------------------- | -------------------------------------------------------- |
| distro                        | `NixOS`                                                  |
| packages                      | `nixos-unstable`                                         |
| android                       | `nix-on-droid`                                           |
| package manager               | `lix`                                                    |
| secrets                       | `sops-nix` `sops`                                        |
| ~ symlinks                    | `hjem`                                                   |
| dotfiles                      | `wrappers`                                               |
| bootloader                    | `systemd-boot` `uboot`                                   |
| secureboot                    | `lanzaboote`                                             |
| kernel                        | `linux-hardened`                                         |
| auditing                      | `auditd`                                                 |
| shell                         | `bash`                                                   |
| filesystem                    | `zfs`                                                    |
| networking                    | `wpa_supplicant`                                         |
| dns                           | `unbound`                                                |
| firewall                      | `iptables (nf_tables)`                                   |
| audio                         | `pipewire`                                               |
| web server                    | `nginx`                                                  |
| media server                  | `jellyfin`                                               |
| display server                | `wayland`                                                |
| compositor                    | `swayfx`                                                 |
| bar                           | `waybar`                                                 |
| widgets                       | `eww`                                                    |
| launcher                      | `rofi`                                                   |
| notifications                 | `dunst`                                                  |
| terminal emulator             | `foot`                                                   |
| file manager                  | `thunar`                                                 |
| pdf reader                    | `zathura`                                                |
| image viewer                  | `swayimg`                                                |
| media player                  | `mpv`                                                    |
| vector graphics editor        | `inkscape`                                               |
| browser                       | `brave`                                                  |
| homepage                      | [`homepage`](https://github.com/sotormd/homepage)        |
| search engine                 | `searxng`                                                |
| bittorrent                    | `qbittorrent-nox`                                        |
| anonymity                     | `i2pd` `oniux` `tor-browser`                             |
| passwords                     | `vaultwarden`                                            |
| text editor                   | [`neovim`](https://github.com/sotormd/neovim) `mousepad` |
| version control               | `git`                                                    |
| development                   | `rust` `python` `go` `haskell`                           |
| themes, icons, cursors, fonts | [`colors`](https://github.com/sotormd/colors)            |
| wallpapers                    | [`wallpapers`](https://github.com/sotormd/wallpapers)    |
| sandboxing                    | `firejail`                                               |
| virtualization                | `qemu` `virt-manager` `distrobox`                        |
| optimizations                 | `auto-cpufreq` `tlp` `powertop`                          |
| resource monitor              | `btop` `htop`                                            |
| clipboard                     | `cliphist`                                               |
| screenshots                   | `grimshot`                                               |
