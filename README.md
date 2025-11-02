# NixOS Configuration Flake

`c:`

~~slighly overengineered~~ NixOS configuration flake for multiple hosts.

<details>

<summary>Click to expand: Full flake tree </summary>

```
github:sotormd/nixos
├── flake.lock
├── flake.nix
├── LICENSE
├── README.md
├── docs
│   ├── droid.md
│   ├── images.md
│   ├── laptop.md
│   ├── rice.md
│   ├── scripts.md
│   ├── server.md
│   ├── example-vars
│   │   ├── example-laptop-vars.nix
│   │   └── example-server-vars.nix
│   └── screenshots
│       └── nixos.gif
├── lib
│   └── default.nix
├── modules
│   ├── common
│   │   ├── default.nix
│   │   ├── audit
│   │   │   ├── accounts.nix
│   │   │   ├── default.nix
│   │   │   ├── logins.nix
│   │   │   ├── privileges.nix
│   │   │   ├── run.nix
│   │   │   ├── security-objects.nix
│   │   │   └── settings.nix
│   │   ├── boot
│   │   │   ├── blacklist.nix
│   │   │   ├── default.nix
│   │   │   ├── jitterentropy.nix
│   │   │   ├── kernel.nix
│   │   │   ├── luks.nix
│   │   │   ├── params.nix
│   │   │   ├── quiet.nix
│   │   │   ├── sysctl.nix
│   │   │   ├── systemd.nix
│   │   │   └── tmp.nix
│   │   ├── clamav
│   │   │   ├── daemon.nix
│   │   │   ├── default.nix
│   │   │   ├── scanner.nix
│   │   │   └── updater.nix
│   │   ├── internationalization
│   │   │   ├── default.nix
│   │   │   ├── keyboard.nix
│   │   │   ├── locales.nix
│   │   │   └── time.nix
│   │   ├── network
│   │   │   ├── adblock.nix
│   │   │   ├── default.nix
│   │   │   ├── disable-ipv6.nix
│   │   │   ├── firewall.nix
│   │   │   ├── host.nix
│   │   │   ├── issue.nix
│   │   │   ├── static.nix
│   │   │   ├── wifi.nix
│   │   │   └── wpa3.nix
│   │   ├── nix
│   │   │   ├── allowed-users.nix
│   │   │   ├── default.nix
│   │   │   ├── dirty-git.nix
│   │   │   ├── flakes.nix
│   │   │   ├── garbage.nix
│   │   │   ├── integrity.nix
│   │   │   ├── ld.nix
│   │   │   └── lix.nix
│   │   ├── packages
│   │   │   ├── default.nix
│   │   │   ├── system.nix
│   │   │   └── user.nix
│   │   ├── sandbox
│   │   │   ├── default.nix
│   │   │   └── firejail.nix
│   │   ├── scripts
│   │   │   ├── bin.nix
│   │   │   ├── default.nix
│   │   │   └── env.nix
│   │   ├── sops
│   │   │   ├── default.nix
│   │   │   ├── gpg.nix
│   │   │   ├── secrets.nix
│   │   │   └── settings.nix
│   │   └── users
│   │       ├── compliance.nix
│   │       ├── default.nix
│   │       ├── git.nix
│   │       ├── immutable.nix
│   │       ├── main.nix
│   │       ├── prompt.nix
│   │       ├── sudo.nix
│   │       └── xdg.nix
│   ├── droid
│   │   ├── colors.nix
│   │   ├── default.nix
│   │   ├── packages.nix
│   │   └── scripts.nix
│   ├── images
│   │   ├── gnome.nix
│   │   ├── minimal.nix
│   │   ├── packages.nix
│   │   └── plasma.nix
│   ├── laptop
│   │   ├── assertions.nix
│   │   ├── default.nix
│   │   ├── home.nix
│   │   ├── audio
│   │   │   ├── alsa.nix
│   │   │   ├── default.nix
│   │   │   ├── jack.nix
│   │   │   ├── pipewire.nix
│   │   │   ├── pulse.nix
│   │   │   └── rtkit.nix
│   │   ├── boot
│   │   │   ├── default.nix
│   │   │   ├── emulation.nix
│   │   │   ├── hw.nix
│   │   │   ├── lanzaboote.nix
│   │   │   ├── loader.nix
│   │   │   ├── plymouth.nix
│   │   │   └── sysctl.nix
│   │   ├── brave
│   │   │   ├── args.nix
│   │   │   ├── default.nix
│   │   │   ├── extensions.nix
│   │   │   ├── firejail.nix
│   │   │   ├── home.nix
│   │   │   ├── package.nix
│   │   │   ├── policies.nix
│   │   │   ├── preferences.nix
│   │   │   ├── sandbox.nix
│   │   │   └── state.nix
│   │   ├── btop
│   │   │   ├── default.nix
│   │   │   └── settings.nix
│   │   ├── cliphist
│   │   │   ├── default.nix
│   │   │   ├── settings.nix
│   │   │   └── start.nix
│   │   ├── codium
│   │   │   ├── default.nix
│   │   │   ├── extensions.nix
│   │   │   ├── firejail.nix
│   │   │   ├── package.nix
│   │   │   ├── sandbox.nix
│   │   │   ├── settings.nix
│   │   │   └── updates.nix
│   │   ├── cpu
│   │   │   ├── auto-cpufreq.nix
│   │   │   ├── default.nix
│   │   │   ├── powertop.nix
│   │   │   └── tlp.nix
│   │   ├── dev
│   │   │   ├── default.nix
│   │   │   ├── go.nix
│   │   │   ├── haskell.nix
│   │   │   ├── python.nix
│   │   │   └── rust.nix
│   │   ├── i2p-browser
│   │   │   ├── css.nix
│   │   │   ├── default.nix
│   │   │   ├── firejail.nix
│   │   │   ├── package.nix
│   │   │   ├── policies.nix
│   │   │   ├── profile.nix
│   │   │   ├── proxy.nix
│   │   │   └── settings.nix
│   │   ├── impermanence
│   │   │   ├── default.nix
│   │   │   ├── home.nix
│   │   │   └── root.nix
│   │   ├── mousepad
│   │   │   ├── config.nix
│   │   │   └── default.nix
│   │   ├── mpv
│   │   │   ├── default.nix
│   │   │   └── settings.nix
│   │   ├── neovim
│   │   │   ├── default.nix
│   │   │   └── editor.nix
│   │   ├── network
│   │   │   ├── default.nix
│   │   │   ├── dns.nix
│   │   │   ├── host.nix
│   │   │   ├── resume.nix
│   │   │   ├── timesyncd.nix
│   │   │   └── tor.nix
│   │   ├── packages
│   │   │   ├── default.nix
│   │   │   ├── mime.nix
│   │   │   ├── system.nix
│   │   │   └── user.nix
│   │   ├── sops
│   │   │   ├── default.nix
│   │   │   ├── secrets.nix
│   │   │   └── settings.nix
│   │   ├── ssh
│   │   │   ├── default.nix
│   │   │   ├── github.nix
│   │   │   └── server.nix
│   │   ├── sway
│   │   │   ├── backgrounds.nix
│   │   │   ├── bindsyms.nix
│   │   │   ├── default.nix
│   │   │   ├── opengl.nix
│   │   │   ├── outputs.nix
│   │   │   ├── ozone.nix
│   │   │   ├── polkit.nix
│   │   │   ├── start.nix
│   │   │   └── swaylock.nix
│   │   ├── thunar
│   │   │   ├── actions.nix
│   │   │   ├── default.nix
│   │   │   ├── gvfs.nix
│   │   │   ├── tumbler.nix
│   │   │   └── xfconf.nix
│   │   ├── users
│   │   │   ├── default.nix
│   │   │   └── xdg.nix
│   │   ├── virtualization
│   │   │   ├── default.nix
│   │   │   ├── distrobox.nix
│   │   │   ├── libvirtd.nix
│   │   │   └── virt-manager.nix
│   │   └── zathura
│   │       ├── colors.nix
│   │       ├── default.nix
│   │       └── fonts.nix
│   ├── rice
│   │   ├── default.nix
│   │   ├── dunst
│   │   │   ├── default.nix
│   │   │   ├── settings.nix
│   │   │   └── start.nix
│   │   ├── eww
│   │   │   ├── config.nix
│   │   │   ├── default.nix
│   │   │   ├── scripts.nix
│   │   │   ├── start.nix
│   │   │   └── style.nix
│   │   ├── foot
│   │   │   ├── colors.nix
│   │   │   ├── default.nix
│   │   │   └── settings.nix
│   │   ├── gtk
│   │   │   ├── cursors.nix
│   │   │   ├── default.nix
│   │   │   ├── fonts.nix
│   │   │   ├── icons.nix
│   │   │   └── themes.nix
│   │   ├── rofi
│   │   │   ├── default.nix
│   │   │   ├── settings.nix
│   │   │   └── start.nix
│   │   ├── sway
│   │   │   ├── backgrounds.nix
│   │   │   ├── bindsyms.nix
│   │   │   ├── default.nix
│   │   │   ├── modes.nix
│   │   │   ├── outputs.nix
│   │   │   ├── swayfx.nix
│   │   │   ├── swaylock.nix
│   │   │   └── sway.nix
│   │   └── waybar
│   │       ├── default.nix
│   │       ├── settings.nix
│   │       ├── start.nix
│   │       └── style.nix
│   └── server
│       ├── assertions.nix
│       ├── default.nix
│       ├── boot
│       │   ├── default.nix
│       │   ├── hw.nix
│       │   └── loader.nix
│       ├── i2pd
│       │   ├── default.nix
│       │   ├── nginx.nix
│       │   └── settings.nix
│       ├── jellyfin
│       │   ├── default.nix
│       │   ├── nginx.nix
│       │   └── service.nix
│       ├── network
│       │   ├── default.nix
│       │   ├── dns.nix
│       │   ├── firewall.nix
│       │   ├── service-fix.nix
│       │   └── start.nix
│       ├── nginx
│       │   ├── acme.nix
│       │   ├── address.nix
│       │   ├── default.nix
│       │   ├── settings.nix
│       │   └── staging.nix
│       ├── nix
│       │   ├── default.nix
│       │   └── limits.nix
│       ├── packages
│       │   ├── default.nix
│       │   ├── system.nix
│       │   └── user.nix
│       ├── qbt
│       │   ├── default.nix
│       │   ├── nginx.nix
│       │   ├── service.nix
│       │   └── user.nix
│       ├── searxng
│       │   ├── default.nix
│       │   ├── engines.nix
│       │   ├── nginx.nix
│       │   ├── settings.nix
│       │   └── uwsgi.nix
│       ├── sops
│       │   ├── default.nix
│       │   ├── secrets.nix
│       │   └── settings.nix
│       ├── ssh
│       │   ├── address.nix
│       │   ├── default.nix
│       │   └── settings.nix
│       ├── unbound
│       │   ├── address.nix
│       │   ├── default.nix
│       │   └── settings.nix
│       └── vaultwarden
│           ├── default.nix
│           ├── nginx.nix
│           └── settings.nix
└── scripts
    ├── commit
    ├── edit
    ├── format
    ├── help
    ├── init
    ├── nixos
    ├── perms
    ├── purge
    ├── repair
    ├── serverpush
    ├── switch
    ├── test
    └── update

66 directories, 280 files
```

</details>

![nixos](./docs/screenshots/nixos.gif)

# Contents

1. [Features](#features)
2. [Setup](#setup)
3. [Images](#images)
4. [nixos: Flake Helper](#nixos-flake-helper)

# Features

|                   |                                                                                    |
| ----------------- | ---------------------------------------------------------------------------------- |
| distro            | `NixOS`                                                                            |
| packages          | `nixos-unstable`                                                                   |
| android           | `nix-on-droid`                                                                     |
| package manager   | `lix`                                                                              |
| secrets           | `sops-nix` `sops`                                                                  |
| bootloader        | `systemd-boot` `uboot`                                                             |
| secureboot        | `lanzaboote`                                                                       |
| kernel            | `linux-hardened`                                                                   |
| auditing          | `auditd`                                                                           |
| shell             | `bash`                                                                             |
| filesystem        | `zfs`                                                                              |
| networking        | `wpa_supplicant`                                                                   |
| dns               | `unbound`                                                                          |
| audio             | `pipewire`                                                                         |
| web server        | `nginx`                                                                            |
| media server      | `jellyfin`                                                                         |
| display server    | `wayland`                                                                          |
| compositor        | `swayfx`                                                                           |
| bar               | `waybar`                                                                           |
| widgets           | `eww`                                                                              |
| launcher          | `rofi`                                                                             |
| notifications     | `dunst`                                                                            |
| terminal emulator | `foot`                                                                             |
| file manager      | `thunar`                                                                           |
| pdf reader        | `zathura`                                                                          |
| image viewer      | `swayimg`                                                                          |
| media player      | `mpv`                                                                              |
| browser           | `brave`                                                                            |
| search engine     | `searxng`                                                                          |
| bittorrent        | `qbittorrent-nox`                                                                  |
| anonymity         | `i2pd` `oniux` `tor-browser`                                                       |
| passwords         | `vaultwarden`                                                                      |
| text editor       | [`neovim`](https://github.com/sotormd/neovim) `vscodium` `nano` `mousepad` `micro` |
| version control   | `git`                                                                              |
| development       | `rust` `python` `go` `haskell`                                                     |
| colorscheme       | [`nord`](https://github.com/sotormd/colors)                                        |
| wallpapers        | [`wallpapers`](https://github.com/sotormd/wallpapers)                              |
| gtk theme         | `Nordic-darker`                                                                    |
| gtk icons         | `Nordzy-dark`                                                                      |
| gtk cursor        | `Simp1e-Nord-Dark`                                                                 |
| font              | `IBM Plex`                                                                         |
| sandboxing        | `firejail`                                                                         |
| virtualization    | `qemu` `virt-manager` `distrobox`                                                  |
| optimizations     | `auto-cpufreq` `tlp` `powertop`                                                    |
| resource monitor  | `btop` `htop`                                                                      |
| clipboard         | `cliphist`                                                                         |
| screenshots       | `grimshot`                                                                         |

# Setup

1. `laptop` role: Laptop configuration

   [Setup docs](./docs/laptop.md)

   To replicate just the desktop, see [rice](./docs/rice.md).

2. `server` role: Headless home server configuration

   [Setup docs](./docs/server.md)

3. `droid` role: nix-on-droid configuration

   [Setup docs](./docs/droid.md)

# Images

Three images: `minimal`, `gnome` and `plasma` are included (for installation,
recovery, etc.)

See [images](./docs/images.md) for more details.

# `nixos` Flake Helper

Usage:

`$ nixos [command] [args]`

When run with **no command**, equivalent to:

`$ nixos tree -I .git -I .local --filesfirst`

When run with a command not listed below, the command is dispatched to
`$NIXOS_DIR`:

`$ nixos vi modules/common/firewall.nix`

## Commands

| Command                            | `laptop` | `server` | Description                                                                                                                                                                                                                                                 |
| ---------------------------------- | -------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `test`                             | ✔        | ✔        | <br>`$ nixos test` <br>Test the current configuration. Does **not** create a boot entry.                                                                                                                                                                    |
| `switch`                           | ✔        | ✔        | <br>`$ nixos switch` <br>Switch to the current configuration. Creates a boot entry.                                                                                                                                                                         |
| `commit`                           | ✔        | ✘        | <br>`$ nixos commit` <br>Switch to and commit the current configuration. Creates a boot entry and a Git commit.                                                                                                                                             |
| `update`                           | ✔        | ✔        | <br>`$ nixos update` <br>Update flake inputs in `flake.lock`.                                                                                                                                                                                               |
| `format`                           | ✔        | ✔        | <br>`$ nixos format` <br>Format the flake using nixfmt.                                                                                                                                                                                                     |
| `perms`                            | ✔        | ✔        | <br>`$ nixos perms` <br>Apply correct permissions to all files in the flake.                                                                                                                                                                                |
| `purge`                            | ✔        | ✔        | <br>`$ nixos purge` <br>Garbage collect old generations.                                                                                                                                                                                                    |
| `repair`                           | ✔        | ✔        | <br>`$ nixos repair` <br>Attempt to repair the nix store.                                                                                                                                                                                                   |
| `edit <vars\|sops>`                | ✔        | ✔        | <br>`$ nixos edit vars` <br>Edit variables file. <br><br>`$ nixos edit sops` <br>Edit sops-nix secrets.                                                                                                                                                     |
| `init <vars\|sops> [replace]`      | ✔        | ✔        | <br>`$ nixos init vars` <br>Initialize variables. <br><br>`$ nixos init vars replace` <br>Replace current variables. <br><br>`$ nixos init sops` <br>Initialize secrets. <br><br>`$ nixos init sops replace` <br>Replace current secrets.                   |
| `init lanzaboote <create\|enroll>` | ✔        | ✘        | <br>`$ nixos init lanzaboote create` <br>Create lanzaboote keys. See [setup docs](docs/laptop.md#6-setting-up-secure-boot). <br><br>`$ nixos init lanzaboote enroll` <br>Enroll lanzaboote keys. See [setup docs](docs/laptop.md#6-setting-up-secure-boot). |
| `init impermanence`                | ✔        | ✘        | <br>`$ nixos init impermanence` <br>Populate the `/persist` directory for impermanence. See [setup docs](docs/laptop.md#7-setting-up-impermanence).                                                                                                         |
| `serverpush <path>`                | ✔        | ✘        | <br>`$ nixos serverpush /nixos` <br>Push the flake to `server:/nixos`.                                                                                                                                                                                      |
| `help`                             | ✔        | ✔        | <br>`$ nixos help` <br>Show this message and exit.                                                                                                                                                                                                          |

See [scripts](./docs/scripts.md) for some detailed examples.
