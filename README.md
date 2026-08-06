<h1 align="center">NixOS Configuration Flake</h1>
<p align="center" style="font-size: 0.3rem;">
    <a href="#features">Features</a> &bull;
    <a href="#configuration-roles">Configuration Roles</a> &bull;
    <a href="#bootstrap-images">Bootstrap Images</a> &bull;
    <a href="#cli">CLI</a> &bull;
    <a href="#architecture">Architecture</a> &bull;
    <a href="#related-flakes">Related Flakes</a>
</p>

![screenshots](./doc/screenshots/nord.gif)

NixOS configuration for multiple hosts.

# Features

[Why do I not use some popular libraries?](./doc/why-not-x.md)

1. Security features:

   - [Security Features Summary](./doc/security.md)

2. Nix-specific features:

   - Completely reproducible, pure evaluation
   - Role-based outputs with features as modules
   - Variables system for device-specific configuration
   - Arbitrary role extensions with [`mkConfig`](./doc/mkconfig.md)
   - Customizable and preconfigured [bootstrap images](#bootstrap-images)
   - Dotfiles managed using wrappers implemented from basic nixpkgs functions
   - Secrets managed using [sops-nix](https://github.com/Mic92/sops-nix)
   - Secure boot using [lanzaboote](https://github.com/nix-community/lanzaboote)
   - Package management using [Lix](https://lix.systems)
   - Optional [non-flake workflow](./doc/nonflake.md)

3. Bespoke components:

   - Bespoke [Impermanence](./doc/filesystems.md#impermanence) implementation
     using ZFS snapshots and bind mounts
   - Bespoke [CLI](#cli) for maintaining this flake, with support for signed
     remote builds
   - Service virtual machines using bespoke
     [svcvm](https://github.com/sotormd/svcvm) backend and `lib.mksvcvm`

4. Desktop features:

   - 100% wayland, no xorg or xwayland
   - [Sway](https://github.com/swaywm/sway) compositor
   - Alternate [cage](https://github.com/cage-kiosk/cage) session with the
     [foot](https://codeberg.org/dnkl/foot) terminal emulator
   - [Waybar](https://github.com/Alexays/Waybar) top panel with several useful
     modules
   - [Rofi](https://github.com/davatorium/rofi) menu for launchers, clipboard
     history, workspace switchers, etc
   - [Brave](https://github.com/brave/brave-browser/) browser with tight
     policies
   - Sandboxing with [Bubblewrap](https://github.com/containers/bubblewrap) and
     [xdg-dbus-proxy](https://github.com/flatpak/xdg-dbus-proxy)
   - XKCD lockscreen wallpapers with
     [xkcd-wall](https://github.com/sotormd/xkcd-wall)
   - Automatic behavior changes when outside trusted & reliable networks with
     [Roaming Mode](./doc/workstation/usage.md#roaming-mode)
   - Full alternate desktop specialisation with
     [GNOME Mode](./doc/workstation/usage.md#gnome-mode)

5. Services features:

   - MicroVM services with [svcvm](https://github.com/sotormd/svcvm)
   - Declarative svcvm management through `lib.mksvcvm`
   - Service readiness and dependency handling
   - WireGuard tunnelling, networkd networking and nftables firewall
   - [Unbound](https://github.com/NLnetLabs/unbound) caching forwarding
     validating DNS server with DoT
   - [NGINX](https://github.com/nginx/nginx) web server & reverse proxy
   - ACME for [Let's Encrypt](https://letsencrypt.org/) certificates
   - [SearXNG](https://github.com/searxng/searxng) search engine
   - [Vaultwarden](https://github.com/dani-garcia/vaultwarden) password manager
   - [i2pd](https://github.com/PurpleI2P/i2pd) I2P router

<details>

<summary>Click to expand: Comprehensive features list</summary>

| Category                      | Stack                                                                                                    |
| ----------------------------- | -------------------------------------------------------------------------------------------------------- |
| distro                        | `NixOS`                                                                                                  |
| packages                      | `nixos-unstable`                                                                                         |
| package manager               | `lix`                                                                                                    |
| kernel                        | `linux`                                                                                                  |
| shell                         | `bash`                                                                                                   |
| malloc                        | `graphene-hardened`                                                                                      |
| bootloader                    | `systemd-boot`, `uboot`                                                                                  |
| secure boot                   | `lanzaboote`                                                                                             |
| filesystem                    | `zfs`                                                                                                    |
| impermanence                  | `zfs(8)` `mount(8)`                                                                                      |
| drive health                  | `smartmontools`                                                                                          |
| dotfiles                      | `nixpkgs` wrappers                                                                                       |
| ~ symlinks                    | `systemd-tmpfiles`                                                                                       |
| auditing                      | `auditd`                                                                                                 |
| secrets                       | `sops`, `sops-nix`                                                                                       |
| keys                          | `age`, `signify`, `gpg`                                                                                  |
| usb policy                    | `usbguard`                                                                                               |
| sandboxing                    | `bubblewrap`, `xdg-dbus-proxy`                                                                           |
| firewall                      | `nftables`                                                                                               |
| mac randomization             | `macchanger`                                                                                             |
| anonymity                     | `i2pd`                                                                                                   |
| networking                    | `systemd-networkd`                                                                                       |
| tunnelling                    | `wireguard`                                                                                              |
| wireless                      | `wpa_supplicant`                                                                                         |
| dns                           | `unbound`                                                                                                |
| secure shell                  | `openssh`                                                                                                |
| display server                | `wayland`                                                                                                |
| compositor                    | `sway`, `cage`                                                                                           |
| bar                           | `waybar`                                                                                                 |
| launcher                      | `rofi`                                                                                                   |
| notifications                 | `dunst`                                                                                                  |
| terminal emulator             | `foot`                                                                                                   |
| file manager                  | `thunar`                                                                                                 |
| audio                         | `pipewire`, `pavucontrol`, `playerctl`                                                                   |
| media player                  | `mpv`                                                                                                    |
| pdf reader                    | `zathura`                                                                                                |
| images                        | `swayimg`                                                                                                |
| vector graphics editor        | `inkscape`                                                                                               |
| screenshots                   | `grimshot`, `grim`, `slurp`                                                                              |
| clipboard                     | `cliphist`                                                                                               |
| browser                       | `brave`                                                                                                  |
| web server                    | `nginx`                                                                                                  |
| certificates                  | `acme`                                                                                                   |
| search engine                 | `searxng`                                                                                                |
| bittorrent                    | `qbittorrent-nox`                                                                                        |
| passwords                     | `vaultwarden`                                                                                            |
| text editor                   | `vim`, `mousepad`                                                                                        |
| version control               | `git`                                                                                                    |
| development                   | `rust`, `python`, `go`, `haskell`                                                                        |
| virtualization                | [`svcvm`](https://github.com/sotormd/svcvm), `lib.mksvcvm` `qemu`, `virt-manager`, `distrobox`, `podman` |
| cpu optimizations             | `auto-cpufreq`                                                                                           |
| resource monitor              | `htop`, `btop`                                                                                           |
| themes, icons, cursors, fonts | `lib.colors`                                                                                             |
| wallpapers                    | `lib.wallpapers`                                                                                         |
| homepage                      | `lib.createHome`                                                                                         |

</details>

# Configuration Roles

This flake uses role-based configuration. These are the available machine roles:

| Role        | Description                            | Documentation                                                                                                                 |
| ----------- | -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Workstation | Configuration for my workstations.     | [Requirements](./doc/workstation/requirements.md) - [Setup](./doc/workstation/setup.md) - [Usage](./doc/workstation/usage.md) |
| Server      | Configuration for my home-servers.     | [Requirements](./doc/server/requirements.md) - [Setup](./doc/server/setup.md) - [Usage](./doc/server/usage.md)                |
| Pi          | Configuration for my Raspberry Pi 4bs. | [Requirements](./doc/pi/requirements.md) - [Setup](./doc/pi/setup.md) - [Usage](./doc/pi/usage.md)                            |

<details>

<summary>Click to expand: All roles</summary>

```
Machines
- machine-workstation
- machine-server
- machine-pi

Bootstrap Images
- image-gnome
- image-minimal
- image-sd
- image-gnome-remote
- image-minimal-remote
- image-sd-remote

Blank Role
- blank
```

</details>

Some previous roles have been moved to separate repos, see
[Related Flakes](#related-flakes).

Any role can be arbitrarily extended using `lib.mkConfig`. This allows defining
your own `nixosConfigurations` using the roles from this repository, while
supplying your own variables, secrets, or additional inputs and modules.

See [`mkConfig` Usage](./doc/mkconfig.md) for more information.

# Bootstrap Images

Three bootstrap images are provided for installation, recovery, and initial
deployment, each providing a preconfigured environment for deploying this
configuration.

Using `lib.mkConfig`, it is also possible to further configure images with
additional options, or configure images for remote installs over wireless
networks with provided modules.

See [Images Documentation](./doc/images.md) for more details.

# CLI

Routine tasks such as updating the flake, switching configurations,
garbage-collecting, and editing variables & secrets are handled through the
bespoke unified `nixos(1)` wrapper CLI.

Manpage:

```bash
man nixos
```

See [CLI Documentation](./doc/cli.md) for the full command reference and
workflow examples.

# Architecture

![architecture](./doc/screenshots/architecture.png)

- [`./modules/`](./modules) are low-level features, which are exposed under
  `nixosModules.modules.*`.
- [`./profiles/`](./profiles) are high-level collections of modules, which are
  exposed under `nixosModules.profiles.*`. These are purely an ease-of-use
  feature, and not another layer of abstraction.
- [`./roles/`](./roles) are the `nixosModules.roles.*` outputs provided by this
  flake, each role is a full system configuration composed of several profiles
  and modules.
- Variables capture the differences between multiple instances of the same role.
  Variables are not provided in this flake and are defined on a per-deployment
  basis.

The roles include both image roles and machine roles. Images are full systems
and can be used directly to build images as covered above. The machine roles in
this repository do not correspond to real hosts - a real host is described by
the combination of a role module along with variables and secrets which are
defined during bootstrap.

This allows the roles to cater to various setups and network topologies. Adding
new hardware and/or distributing services across new hardware should involve
zero code changes to this flake, and are entirely handled by variables.

None of this really relies on flakes or flake-specific features, as exemplified
by the optional [non-flake workflow](./doc/nonflake.md).

The configurations are created using [`mkConfig`](./doc/mkconfig.md). Each
`nixosConfiguration` consists of:

- A `nixosModules.roles.*` module, which includes various `modules` and
  `profiles`
- Flake-specific/Non-Flake glue for things like `inputs`, `self` and `lib`
- Variables & Secrets (for machine roles only)
- Optional additional values with `extra{Inputs,Self,Lib,SpecialArgs}`

Since every `nixosConfigurations` attr in this repository is built using
`lib.mkConfig`, the same interface can also be used externally to create new
configurations based on the provided roles, add inputs, add modules, or supply
variables and secrets.

See [`mkConfig` Usage](./doc/mkconfig.md) for more information.

# Related Flakes

Here are some of my other flakes that are related to my NixOS tooling:

Directly dependent:

- [svcvm](https://github.com/sotormd/svcvm), Service virtual machines for NixOS,
  derived from [microvm.nix](https://github.com/microvm-nix/microvm.nix)

Others:

- [neovim](https://github.com/sotormd/neovim), Neovim configuration flake (ft.
  nvf)
- [pattern](https://github.com/sotormd/pattern), Atomic, image-based systems
  with A/B updates, provisioned using Nix
- [polevault](https://github.com/sotormd/polevault), A
  [pattern](https://github.com/sotormd/pattern) to access backup vaultwarden
  vaults when away from main server
- [flag](https://github.com/sotormd/flag), A
  [pattern](https://github.com/sotormd/pattern) for my VMs
- [nate](https://github.com/sotormd/nate), MATE desktop for my NixOS needs
- [coffee](https://github.com/sotormd/coffee), A very minimal openbox
  configuration
- [droid](https://github.com/sotormd/droid), nix-on-droid configuration

Some of these repos were previously part of this repo, but separated due to
being out-of-scope (eg, [pattern](https://github.com/sotormd/pattern)).

Others are still in-scope, but are maintained separately for simplicity (eg,
[droid](https://github.com/sotormd/droid)).
