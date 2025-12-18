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

See [Features](#features--tooling) for all features.

# Contents

1. [Setup & Usage](#setup--usage)
2. [Images](#images)
3. [nixos: Flake Helper](#nixos-flake-helper)
4. [Features & Tooling](#features--tooling)

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

# Features & Tooling

| Category                      | Stack                                                                                                      |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------- |
| distro                        | `NixOS`                                                                                                    |
| packages                      | `nixos-unstable`                                                                                           |
| package manager               | `lix`                                                                                                      |
| shell                         | `bash`                                                                                                     |
| kernel                        | `linux-hardened`                                                                                           |
| bootloader                    | `systemd-boot`, `uboot`                                                                                    |
| secure boot                   | `lanzaboote`                                                                                               |
| filesystem                    | `zfs`                                                                                                      |
| impermanence                  | ZFS snapshots, bind mounts                                                                                 |
| ~ symlinks                    | `hjem`                                                                                                     |
| dotfiles                      | custom wrappers                                                                                            |
| auditing                      | `auditd`                                                                                                   |
| secrets                       | `sops`, `sops-nix`                                                                                         |
| sandboxing                    | `firejail`                                                                                                 |
| firewall                      | `iptables (nf_tables)`                                                                                     |
| anonymity                     | `i2pd`, `oniux`, `tor-browser`                                                                             |
| networking                    | `wpa_supplicant`                                                                                           |
| DNS                           | `unbound`                                                                                                  |
| display server                | `wayland`                                                                                                  |
| compositor                    | `swayfx`                                                                                                   |
| bar                           | `waybar`                                                                                                   |
| widgets                       | `eww`                                                                                                      |
| launcher                      | `rofi`                                                                                                     |
| notifications                 | `dunst`                                                                                                    |
| terminal emulator             | `foot`                                                                                                     |
| file manager                  | `thunar`                                                                                                   |
| audio                         | `pipewire`                                                                                                 |
| media player                  | `mpv`                                                                                                      |
| pdf reader                    | `zathura`                                                                                                  |
| image viewer                  | `swayimg`                                                                                                  |
| vector graphics editor        | `inkscape`                                                                                                 |
| screenshots                   | `grimshot`                                                                                                 |
| clipboard                     | `cliphist`                                                                                                 |
| browser                       | `brave`                                                                                                    |
| web server                    | `nginx`                                                                                                    |
| homepage                      | [`homepage`](https://github.com/sotormd/homepage)                                                          |
| search engine                 | `searxng`                                                                                                  |
| media server                  | `jellyfin`                                                                                                 |
| bittorrent                    | `qbittorrent-nox`                                                                                          |
| passwords                     | `vaultwarden`                                                                                              |
| text editor                   | [`neovim`](https://github.com/sotormd/neovim), `mousepad`                                                  |
| version control               | `git`                                                                                                      |
| development                   | `rust`, `python`, `go`, `haskell`                                                                          |
| virtualization                | `qemu`, `virt-manager`, `distrobox`                                                                        |
| optimizations                 | `auto-cpufreq`, `tlp`, `powertop`                                                                          |
| resource monitor              | `btop`, `htop`                                                                                             |
| android                       | `nix-on-droid`                                                                                             |
| themes, icons, cursors, fonts | [`colors`](https://github.com/sotormd/colors)                                                              |
| wallpapers                    | [`wallpapers`](https://github.com/sotormd/wallpapers), [`xkcd-wall`](https://github.com/sotormd/xkcd-wall) |
