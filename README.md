# NixOS Configuration Flake

NixOS configuration flake for multiple hosts.

![Screenshot](docs/screenshot.png)

# Features

|                   |                                       |
|-------------------|---------------------------------------|
| distro            | `NixOS`                               |
| packages          | `nixos-unstable`                      |
| package manager   | `lix`                                 |
| secrets           | `sops-nix` `sops`                     |
| bootloader        | `systemd-boot` `uboot`                |
| secureboot        | `lanzaboote`                          |
| kernel            | `linux-hardened`                      |
| filesystem        | `zfs`                                 |
| networking        | `wpa_supplicant`                      |
| dns               | `unbound`                             |
| display server    | `wayland`                             |
| compositor        | `swayfx`                              |
| bar               | `waybar`                              |
| widgets           | `eww`                                 |
| launcher          | `rofi-wayland`                        |
| notifications     | `dunst`                               |
| file manager      | `thunar`                              |
| pdf reader        | `zathura`                             |
| image viewer      | `swayimg`                             |
| media player      | `mpv`                                 |
| browser           | `brave`                               |
| search engine     | `searxng`                             |
| anonymity         | `i2pd` `oniux` `tor-browser`          |
| passwords         | `vaultwarden`                         |
| text editor       | `neovim` `vscodium` `nano` `mousepad` |
| gtk theme         | `Nordic-darker`                       |
| gtk icons         | `Nordzy-dark`                         |
| gtk cursor        | `Simp1e-Nord-Dark`                    |
| font              | `IBM Plex`                            |
| sandboxing        | `firejail`                            |
| virtualization    | `qemu` `virt-manager` `distrobox`     |
| optimizations     | `auto-cpufreq` `tlp` `powertop`       |
| web server        | `nginx`                               |
| media server      | `jellyfin`                            |

# Setup

[laptop setup](./docs/laptop-setup.md)

[server setup](./docs/server-setup.md)

# Maintenance

#### View flake tree

```
$ nixos
```

#### Run command in flake directory

```
$ nixos $COMMAND_HERE
```

eg.

```
$ nixos nano modules/common/network/firewall.nix
```

#### Edit variables and secrets

```
$ nixos edit vars
$ nixos edit sops
```

#### Test a new configuration

```
$ nixos test
```

#### Switch to a new configuration

```
$ nixos switch
```

#### Switch to and commit a new configuration

```
$ nixos commit
```

#### Update flake inputs

```
$ nixos update
```

#### Garbage collect

```
$ nixos purge
```

#### Format flake

```
$ nixos format
```

#### Fix file permissions

```
$ nixos perms
```

#### Repair nix store

```
$ nixos repair
```
