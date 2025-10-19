# NixOS Configuration Flake

NixOS configuration flake for multiple hosts.

![Screenshot](docs/screenshot.png)

# Features

|                   |                                                                                     |
|-------------------|-------------------------------------------------------------------------------------|
| distro            | `NixOS`                                                                             |
| packages          | `nixos-unstable`                                                                    |
| package manager   | `lix`                                                                               |
| secrets           | `sops-nix` `sops`                                                                   |
| bootloader        | `systemd-boot` `uboot`                                                              |
| secureboot        | `lanzaboote`                                                                        |
| kernel            | `linux-hardened`                                                                    |
| auditing          | `auditd`                                                                            |
| shell             | `bash`                                                                              |
| filesystem        | `zfs`                                                                               |
| networking        | `wpa_supplicant`                                                                    |
| dns               | `unbound`                                                                           |
| audio             | `pipewire` `pulseaudio`                                                             |
| web server        | `nginx`                                                                             |
| media server      | `jellyfin`                                                                          |
| display server    | `wayland`                                                                           |
| compositor        | `swayfx`                                                                            |
| bar               | `waybar`                                                                            |
| widgets           | `eww`                                                                               |
| launcher          | `rofi`                                                                              |
| notifications     | `dunst`                                                                             |
| terminal emulator | `foot`                                                                              |
| file manager      | `thunar`                                                                            |
| pdf reader        | `zathura`                                                                           |
| image viewer      | `swayimg`                                                                           |
| media player      | `mpv`                                                                               |
| browser           | `brave`                                                                             |
| search engine     | `searxng`                                                                           |
| anonymity         | `i2pd` `oniux`                                                                      |
| passwords         | `vaultwarden`                                                                       |
| text editor       | [`neovim`](https://github.com/sotormd/neovim) `vscodium` `nano` `mousepad` `micro`  |
| version control   | `git`                                                                               |
| development       | `rust` `python` `go` `haskell`                                                      |
| colorscheme       | [`nord`](https://github.com/sotormd/colors)                                         |
| wallpapers        | [`wallpapers`](https://github.com/sotormd/wallpapers)                               |
| gtk theme         | `Nordic-darker`                                                                     |
| gtk icons         | `Nordzy-dark`                                                                       |
| gtk cursor        | `Simp1e-Nord-Dark`                                                                  |
| font              | `IBM Plex`                                                                          |
| sandboxing        | `firejail`                                                                          |
| virtualization    | `qemu` `virt-manager` `distrobox`                                                   |
| optimizations     | `auto-cpufreq` `tlp` `powertop`                                                     |
| resource monitor  | `btop` `htop`                                                                       |
| clipboard         | `cliphist`                                                                          |
| screenshots       | `grimshot`                                                                          |

# Setup

[laptop setup](./docs/laptop-setup.md)

[server setup](./docs/server-setup.md)

# `nixos` Flake Helper

Usage:

`$ nixos [command] [args]`

When run with **no command**, equivalent to:

`$ nixos tree -I .git -I .local --filesfirst`

When run with a command not listed below, the command is dispatched to `$NIXOS_DIR`:

`$ nixos vi modules/common/firewall.nix`

## Commands

| Command                            | `laptop` | `server` | Description                                                                                                                                            |
|------------------------------------|----------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| `test`                             | ✔      | ✔      | <br>`$ nixos test` <br>Test the current configuration. Does **not** create a boot entry.                                                                   |
| `switch`                           | ✔      | ✔      | <br>`$ nixos switch` <br>Switch to the current configuration. Creates a boot entry.                                                                        |
| `commit`                           | ✔      | ✘      | <br>`$ nixos commit` <br>Switch to and commit the current configuration. Creates a boot entry and a Git commit.                                            |
| `update`                           | ✔      | ✔      | <br>`$ nixos update` <br>Update flake inputs in `flake.lock`. <br>Equivalent to: `$ nixos nix flake update`.                                               |
| `format`                           | ✔      | ✔      | <br>`$ nixos format` <br>Format the flake using nixfmt. <br>Equivalent to: `$ nixos find . -type f -name '*.nix' -exec nix fmt {} +`.                      |
| `perms`                            | ✔      | ✔      | <br>`$ nixos perms` <br>Apply correct permissions to all files in the flake.                                                                               |
| `purge`                            | ✔      | ✔      | <br>`$ nixos purge` <br>Garbage collect old generations. <br>Equivalent to: `$ sudo nix-collect-garbage --delete-old`.                                     |
| `repair`                           | ✔      | ✔      | <br>`$ nixos repair` <br>Attempt to repair the nix store. <br>Equivalent to: `$ sudo nix-store --verify --check-contents --repair`.                        |
| `edit <vars\|sops>`                | ✔      | ✔      | <br>`$ nixos edit vars` <br>Edit variables file. <br><br>`$ nixos edit sops` <br>Edit sops-nix secrets.                                                    |
| `init <vars\|sops> [replace]`      | ✔      | ✔      | <br>`$ nixos init vars` <br>Initialize variables. <br><br>`$ nixos init vars replace` <br>Replace current variables. <br><br>`$ nixos init sops` <br>Initialize secrets. <br><br>`$ nixos init sops replace` <br>Replace current secrets. |
| `init lanzaboote <create\|enroll>` | ✔      | ✘      | <br>`$ nixos init lanzaboote create` <br>Create lanzaboote keys. See [setup docs](docs/laptop-setup.md#6-setting-up-secure-boot). <br><br>`$ nixos init lanzaboote enroll` <br>Enroll lanzaboote keys. See [setup docs](docs/laptop-setup.md#6-setting-up-secure-boot). |
| `init impermanence`                | ✔      | ✘      | <br>`$ nixos init impermanence` <br>Populate the `/persist` directory for impermanence. See [setup docs](docs/laptop-setup.md#7-setting-up-impermanence).  |
| `serverpush <path>`                | ✔      | ✘      | <br>`$ nixos serverpush /nixos` <br>Push the flake to `server:/nixos`.                                                                                     |
| `help`                             | ✔      | ✔      | <br>`$ nixos help` <br>Show this message and exit.                                                                                                         |

See [scripts](./docs/scripts.md) for some detailed examples.
