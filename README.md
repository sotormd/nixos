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

Desktop features:

- 100% wayland, no xorg or xwayland
- [swayfx](https://github.com/WillPower3309/swayfx) compositor
- [waybar](https://github.com/Alexays/Waybar) top panel with several useful
  modules
- [eww](https://github.com/elkowar/eww) widgets for bottom dock, dashboard,
  calendar, etc
- [rofi](https://github.com/davatorium/rofi) menu for launchers, clipboard
  history, workspace switchers, etc.
- [Brave](https://github.com/brave/brave-browser/) browser with tight policies
  to ensure security and protect user privacy.
- nvf-powered [neovim](https://github.com/sotormd/neovim) configuration
- theming and colors with [colors](https://github.com/sotormd/colors)
- declarative browser homepage with
  [homepage](https://github.com/sotormd/homepage)
- declarative wallpapers with
  [wallpapers](https://github.com/sotormd/wallpapers)
- xkcd lockscreen wallpapers with
  [xkcd-wall](https://github.com/sotormd/xkcd-wall)

Services features:

- [unbound](https://github.com/NLnetLabs/unbound) dns server
- [nginx](https://nginx.org/en/) web server & reverse proxy
- acme for [Let's Encrypt](https://letsencrypt.org/) certificates
- [searxng](https://github.com/searxng/searxng) search engine
- [vaultwarden](https://github.com/dani-garcia/vaultwarden) password manager
- [i2pd](https://github.com/PurpleI2P/i2pd) I2P router
- [jellyfin](https://jellyfin.org/) media server

See [Features](#features--tooling) for all features.

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
| anonymity                     | `i2pd`, `oniux`                                                                                            |
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
| certificates                  | `acme`                                                                                                     |
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
