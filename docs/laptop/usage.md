# `laptop` Usage

This document covers using the `laptop` role.

# Contents

1. [System Maintenance](#system-maintenance)
2. [Using the Sway desktop](#using-the-sway-desktop)
3. [Adding External Disks](#adding-external-disks)
4. [Browsers](#browsers)
5. [Other Applications](#other-applications)
6. [Virtualisation and Containers](#virtualisation-and-containers)
7. [Nomad Mode](#nomad-mode)

# System Maintenance

## Routine Tasks

Routine tasks such as updating the flake, switching configurations,
garbage-collecting, repairing the Nix store, and editing variables & secrets are
handled through the unified `nixos(1)` helper CLI.

Manpage:

```bash
man nixos
```

Overview:

```bash
nixos help
```

See [scripts.md](../scripts.md) for the full command reference and workflow
examples.

## Variables and Secrets

The flake uses variables for device-specific configuration.

For example, server services can be configured and external drives can be
mounted via the variables file. To edit the variables file:

```bash
nixos edit vars
```

The flake uses secrets (via `sops`) for sensitive information.

For example, the hashed user password, the network PSK, the DuckDNS API key,
etc. are configured via `sops`. To edit the sops file:

```bash
nixos edit sops
```

# Using the Sway Desktop

The full sway config lives [here](../../modules/laptop/sway/config.nix).

## Logging In

Logging in to `tty1` will drop you into the `sway` desktop.

This is possible due to this line in the login shell configuration:

```bash
if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec sway
fi
```

Logging in to any other `tty` will drop you into the default shell, `bash`.

## Basic Motions

The basic motions are identical to the default `i3` / `sway` motions.

Note: `$mod` is `Mod4` (the `Super` / `Windows` key).

| Action                                           | Keybind                             |
| ------------------------------------------------ | ----------------------------------- |
| Focus left container                             | `$mod+Left` / `$mod+h`              |
| Focus right container                            | `$mod+Right` / `$mod+l`             |
| Focus up container                               | `$mod+Up` / `$mod+k`                |
| Focus down container                             | `$mod+Down` / `$mod+j`              |
| Move container left                              | `$mod+Shift+Left` / `$mod+Shift+h`  |
| Move container right                             | `$mod+Shift+Right` / `$mod+Shift+l` |
| Move container up                                | `$mod+Shift+Up` / `$mod+Shift+k`    |
| Move container down                              | `$mod+Shift+Down` / `$mod+Shift+j`  |
| Go to workspace `1..10`                          | `$mod+1..0`                         |
| Move container to workspace `1..10`              | `$mod+Shift+1..0`                   |
| Go to next workspace                             | `$mod+PgDown` / `$mod+ctrl+Right`   |
| Go to previous workspace                         | `$mod+PgUp`/ `$mod+ctrl+Left`       |
| Fetch containers from scratchpad                 | `$mod+Minus`                        |
| Move container to scratchpad                     | `$mod+Shift+Minus`                  |
| Toggle focus between floating / tiled containers | `$mod+Space`                        |
| Toggle floating / tiled                          | `$mod+Shift+Space`                  |
| Close current container                          | `$mod+Shift+q`                      |
| Split vertical                                   | `$mod+v`                            |
| Split horizontal                                 | `$mod+b`                            |
| Toggle split layout                              | `$mod+e`                            |
| Tabbed layout                                    | `$mod+w`                            |
| Stacking layout                                  | `$mod+s`                            |
| Fullscreen                                       | `$mod+f`                            |
| Focus parent                                     | `$mod+a`                            |

Workspaces can also be changed using the `rofi` launcher, see
[workspace switcher](#workspace-switcher).

## Launching Apps

| Action                 | Keybind          |
| ---------------------- | ---------------- |
| Launch terminal `foot` | `$mod+Return`    |
| Launch browser `brave` | `$mod+backslash` |
| Launch launcher `rofi` | `$mod+d`         |

The `rofi` launcher has several other uses, see:
[Launcher, rofi](#launcher-rofi)

## Additional Keybinds

| Action              | Keybind                 |
| ------------------- | ----------------------- |
| Play / Pause media  | `XF86AudioPlay`         |
| Stop media          | `$mod+XF86AudioPlay`    |
| Next media          | `XF86AudioNext`         |
| Previous media      | `XF86AudioPrev`         |
| Mute audio          | `XF86AudioMute`         |
| Increase volume     | `XF86AudioRaiseVolume`  |
| Decrease volume     | `XF86AudioLowerVolume`  |
| Increase brightness | `XF86MonBrightnessUp`   |
| Decrease brightness | `XF86MonBrightnessDown` |
| Translucent window  | `$mod+t`                |
| Opaque window       | `$mod+o`                |

All media commands are dispatched via `playerctl`.

All audio commands are dispatched via `wpctl` and applied to the default sink.

All brightness commands are dispatched via `brightnessctl`.

The `volume` and `brightness` commands are wrappers which display a `dunst`
notification with a bar indicator.

The media, audio and brightness can also be controlled via waybar:

- Media: [playerctl Module](#playerctl-module)
- Audio: [audio Module](#audio-module)
- Brightness: [battery Module](#battery-module)

## Modes

Return to normal mode from any other mode by using `Escape` / `Return`.

### Resize

Enter resize mode by using `$mod+r`

| Action        | Keybind       |
| ------------- | ------------- |
| shrink height | `Up` / `k`    |
| shrink width  | `Left` / `h`  |
| grow height   | `Down` / `j`  |
| grow width    | `Right` / `l` |

### Leave

Enter leave mode by using `$mod+Escape`

| Action   | Keybind |
| -------- | ------- |
| Lock     | `l`     |
| Logout   | `x`     |
| Suspend  | `s`     |
| Poweroff | `u`     |
| Reboot   | `r`     |

Entering leave mode also opens the eww [leave](#leave-widget) widget.

### Screenshot

Enter screenshot mode by using `$mod+PrintScreen`

| Action       | Keybind |
| ------------ | ------- |
| copy area    | `ca`    |
| save area    | `sa`    |
| copy window  | `cw`    |
| save window  | `sw`    |
| copy screen  | `cs`    |
| save screen  | `ss`    |
| color picker | `p`     |

You can also use `$mod+Shift+s` in normal mode to copy area.

All screenshot commands are dispatched via `grimshot`.

The color picker copies the hex code to the clipboard.

## Top panel, waybar

The full waybar config lives [here](../../modules/laptop/waybar/config.nix).

Styling options live [here](../../modules/laptop/waybar/style.nix).

### workspaces Module

![waybar workspaces](../screenshots/waybar-workspaces.png)

Shows workspaces.

| Action          | Bind       |
| --------------- | ---------- |
| Go to workspace | Left click |

Current workspace is highlighted in bold.

### playerctl Module

![waybar playerctl](../screenshots/waybar-playerctl.png)

Shows currently playing track.

| Action           | Bind         |
| ---------------- | ------------ |
| Play / pause     | Left click   |
| Stop             | Middle click |
| Next             | Scroll up    |
| Previous         | Scroll down  |
| Toggle animation | Right click  |

### mode Module

Shows current mode.

Nothing is shown for normal mode.

### title Module

Shows title of current container.

### idle_inhibitor Module

![waybar idle](../screenshots/waybar-idle.png)

| Action                                      | Bind       |
| ------------------------------------------- | ---------- |
| Toggle inhibiting automatic session locking | Left click |

### userns Module

![waybar userns](../screenshots/waybar-userns.png)

| Action                                    | Bind       |
| ----------------------------------------- | ---------- |
| Toggle `kernel.unprivileged_userns_clone` | Left click |

### network Module

![waybar network](../screenshots/waybar-network.png)

Shows current connection status / band / ssid name.

| Action                  | Bind         |
| ----------------------- | ------------ |
| Toggle band / ssid view | Left click   |
| Reassociate             | Right click  |
| Disconnect              | Middle click |

### audio Module

![waybar audio](../screenshots/waybar-audio.png)

Shows current volume.

| Action               | Bind        |
| -------------------- | ----------- |
| Toggle muting        | Left click  |
| Launch `pavucontrol` | Right click |
| Increase volume      | Scroll up   |
| Decrease volume      | Scroll down |

### battery Module

![waybar battery](../screenshots/waybar-battery.png)

Shows current battery percentage / remaining time.

| Action                        | Bind        |
| ----------------------------- | ----------- |
| Toggle percentage / time view | Left click  |
| Increase brightness           | Scroll up   |
| Decrease brightness           | Scroll down |

### clock Module

![waybar clock](../screenshots/waybar-clock.png)

Shows current time.

| Action                                   | Bind       |
| ---------------------------------------- | ---------- |
| Open [calendar](#calendar-widget) widget | Left click |

## Widgets, eww

The full eww config lives [here](../../modules/laptop/eww/config.nix).

Styling options live [here](../../modules/laptop/eww/style.nix).

Scripts used in the widgets live [here](../../modules/laptop/eww/scripts.nix).

### Dock widget

Toggle dock visibility using `$mod+Tab`.

![eww dock](../screenshots/eww-dock.png)

The icons represent apps. Each icon can have three states:

| State       | Icon Appearance     | Description              |
| ----------- | ------------------- | ------------------------ |
| `empty`     | Grey                | No window open           |
| `unfocused` | Blue                | At least one window open |
| `focused`   | Blue with underline | Currently focused window |

The following actions can be done on an `empty` icon:

| Action     | Bind       |
| ---------- | ---------- |
| Launch app | Left click |

The following actions can be done on an `unfocused` icon:

| Action                 | Bind       |
| ---------------------- | ---------- |
| Focus last used window | Left click |

The following actions can be done on a `focused` icon:

| Action                         | Bind         |
| ------------------------------ | ------------ |
| Toggle floating / tiled mode   | Left click   |
| Send to scratchpad             | Right click  |
| Close current window           | Middle click |
| Focus through all open windows | Scroll       |

The configuration for the dock, including pinned icons are defined
[here](../../modules/laptop/eww/dock-clients.json).

Use the `eww-dock-init` command to reload the dock scripts.

### Start widget

Toggle start widget visibility using `$mod+grave`.

![eww start](../screenshots/eww-start.png)

Included modules:

- username
- hostname
- uptime
- cpu usage
- memory usage
- ZFS usage
- playerctl controls
- lyrics
- fortune
- leave commands

### Calendar widget

Open by left clicking on the waybar [clock](#clock-module) module.

![eww calendar](../screenshots/eww-calendar.png)

Use the arrows or scroll to change the month / year.

Current day is highlighted in purple.

Click on the purple calendar icon or use the `eww-cal-init` command to reload
calendar scripts.

### Leave widget

The leave widget opens on entering [leave](#leave) mode.

The leave widget closes on returning to normal mode.

![eww leave](../screenshots/eww-leave.png)

Instead of using the keybinds of leave mode, you can click on the buttons on
this widget instead.

## Launcher, rofi

The full rofi config lives [here](../../modules/laptop/rofi/config.nix).

Styling options live [here](../../modules/laptop/rofi/style.nix).

### run

Launch using `$mod+d`.

![rofi run](../screenshots/rofi-run.png)

### workspace switcher

Launch using `$mod+g` for focusing a workspace.

Launch using `$mod+Shift+g` for moving current container to a workspace.

### clipboard history

Launch using `$mod+c`.

Shows complete clipboard history using `cliphist`.

Select an item to copy it to the clipboard.

Along with the traditional keybinds, you can use `wl-copy` or `wl-paste` to add
things to / paste things from the clipboard.

## Wallpapers

To change the current wallpaper, change the `vars.outputs.wallpaper` and
`vars.outputs.lockscreen` variables.

Any wallpaper from [wallpapers](https://github.com/sotormd/wallpapers) can be
used.

For example to use `wallpapers/nord/building.png`, the variable should be set to
`"nord.building"`.

To use your own wallpapers, change the `wallpapers` input in
[flake.nix](../../flake.nix) to a flake that exposes similar outputs.

The `vars.output.lockscreen` can also be one of `xkcd.today` or `xkcd.random`
for xkcd comics.

See [xkcd-wall](https://github.com/sotormd/xkcd-wall) for more information.

## Colors & Theming

By default, the Nord palette is used.

All colors and theming options are defined in
[colors](https://github.com/sotormd/colors).

To use a different colorscheme, change the `colors` input in
[flake.nix](../../flake.nix).

Examples:

| Colorscheme | Input URL                                              |
| ----------- | ------------------------------------------------------ |
| nord        | `github:sotormd/colors` / `github:sotormd/colors/nord` |
| gruvbox     | `github:sotormd/colors/gruvbox`                        |

To use your own colorscheme, change the input to a flake that exposes similar
outputs.

# Browsers

Three web browsers: `brave`, `i2p-browser` and `vanilla-browser` are included.

| Name              | Browser  | Description                                          |
| ----------------- | -------- | ---------------------------------------------------- |
| `brave`           | Brave    | Primary, hardened browser                            |
| `i2p-browser`     | Firefox  | Browser for the I2P network                          |
| `vanilla-browser` | Chromium | Ephemeral vanilla browser with Windows 11 user agent |

## Brave

### Launching

The Brave browser can be launched using the shortcut `$mod+backslash` or by
executing the firejail wrapper:

```bash
brave
```

### Configuration

Note that the `~/.config/BraveSoftware/Brave-Browser/` directory is persisted by
impermanence so all state is persisted across reboots.

The included brave browser is heavily policied via chromium policies. The full
list of policies live [here](../../modules/laptop/brave/policies.nix). The
policies include options to disable several anti-features, particularly those
related to crypto and web3.

The included brave browser also strips out any telemetry by setting initial
preferences and local state files. The initial preferences live
[here](../../modules/laptop/brave/preferences.nix) and the local state lives
[here](../../modules/laptop/brave/state.nix).

### Extensions

The browser also comes with these
[extensions](../../modules/laptop/brave/extensions.nix) to preserve privacy and
improve usability.

- uBlock Origin
- Darkreader
- Bitwarden
- Vimium

uBlock Origin is also configured further via chromium policies.

### Sandbox

The `brave` executable provided is a firejail wrapper. All firejail flags can be
seen [here](../../modules/laptop/brave/firejail.nix).

Note that to run the brave browser, you will have to enable unprivileged user
namespaces, which is disabled by default. It can be enabled by setting the
`kernel.unprivileged_userns_clone` sysctl to `1` or via the waybar
[userns](#userns-module) module.

Using the brave browser without enabling unprivileged user namespaces is
possible, but requires a workaround. The brave browser uses the chromium
namespaces sandbox by default, you can check by visiting `brave://sandbox`. If
unprvileged user namespaces are disabled, then brave will fall back to using the
chromium SUID sandbox.

However, firejail doesn't allow using the chromium SUID sandbox from within a
firejail sandbox. So you must run brave outside of firejail. See
[here](../../modules/laptop/brave/sandbox.nix) for instructions. This however is
not recommended unless you absolutely have to avoid unprivileged user
namespaces.

### WebApps

The web app for `spotify` is also installed, and more web apps can be added
[here](../../modules/laptop/brave/webapps.nix). The web apps also run under
firejail.

## i2p-browser

The i2p-browser can be launched by executing the firejail wrapper:

```bash
i2p-browser
```

The i2p-browser is just the Firefox browser with several configuration settings
to allow browsing the I2P network. The additional configuration options can be
found [here](../../modules/laptop/i2p-browser/profile.nix) and policies
[here](../../modules/laptop/i2p-browser/policies.nix).

The i2p-browser uses the I2P HTTP Proxy from `network.server.i2p.port` in the
variables.

The included `i2p-browser` executable is a firejail wrapper. All firejail flags
can be seen [here](../../modules/laptop/i2p-browser/firejail.nix).

## vanilla-browser

The vanilla-browser can be launched by executing the firejail wrapper:

```bash
vanilla-browser
```

The vanilla-browser runs in a `--private` firejail, all flags can be seen
[here](../../modules/laptop/vanilla-browser/firejail.nix). This means that it
can't write to the user's home directory like Brave or i2p-browser.

The vanilla-browser also sets the user agent to show Windows 11.

It is not configured at all, and is mostly vanilla Chromium.

# Other Applications

## foot

Terminal emulator for wayland.

Launch using `$mod+Return`

## Thunar

File manager from the XFCE desktop environment.

## mousepad

Text editor from the XFCE desktop environment.

## swayimg

Simple image viewer for wayland.

## mpv

Media player supporting a wide variety of file formats.

## zathura

PDF viewer with vim-like keybinds.

## Inkscape

Scalable vector graphics editor.

## file-roller

Archive manager from the GNOME desktop environment.

# Virtualisation and Containers

Virtual machines and containers allow running isolated environments.

## Virtual Machines

Virtual machines can be created using QEMU/KVM through `virt-manager`.

To launch the Virtual Machine Manager:

```bash
virt-manager
```

It can also be launched from [rofi](#launcher-rofi).

Created virtual machines are lost on reboot, since impermanence does not persist
these directories. To persist across reboots, store these under `/persist` or
add these directories to the impermanence setup.

An alternative to creating persistent VM disks is to use ZFS ZVOLs to store
them.

For example, to create a 1TB ZVOL:

```bash
sudo zfs create -o compression=zstd rpool/vms 
sudo zfs create -o volblocksize=16K -V 1T rpool/vms/solaris
```

ZVOLs are thin-provisioned by default, so the full size is not allocated at
creation. Space is consumed only as the VM writes data.

Using `16K` as the `volblocksize` is optimal for VM workloads. Using `zstd`
gives decent compression ratios.

Now you can use `/dev/zvol/rpool/vms/solaris` as the block device for your
virtual machines.

This way, you can manage snapshots using ZFS as well:

```bash
sudo zfs snapshot rpool/vms/solaris@snap1
sudo zfs rollback rpool/vms/solaris@snap1
```

## Distrobox

`distrobox` allows for using other distributions under rootless containers on
the NixOS host system.

Example: To create a new container using Debian Stable

```bash
distrobox create debian -i debian:stable
```

To enter this container:

```bash
distrobox enter debian
```

See the manpage for more information:

```bash
man distrobox
```

Created containers are lost on reboot, since impermanence does not persist these
directories. To persist across reboots, store these under `/persist` or add
these directories to the impermanence setup.

`distrobox` requires the use of unprivileged user namespaces, which is disabled
by default. It can be enabled by setting the `kernel.unprivileged_userns_clone`
sysctl to `1` or via the waybar [userns](#userns-module) module.

## Podman

Podman, a simple management tool for pods, containers and images is installed.

See the manpage for more information:

```bash
man podman
```

Podman is also used as the backend for Distrobox.

# Nomad Mode

Nomad Mode refers to the specialisation `nomad`, which sets up an environment
ideal for usage away from home, in unreliable conditions.

Notable changes from default `laptop` config:

- sway window manager replaced by full GNOME desktop environment
- wpa_supplicant replaced by NetworkManager
- unbound from `server` replaced by cloudflare DNS
- `kernel.unprivileged_userns_clone` set to 1 by default
- librewolf browser is installed
- flatpak is enabled, and flathub is added as a repo
- apps can be installed from GNOME software

Nomad Mode can be used by booting into the `nomad` specialisation from the boot
menu.

> Nomad Mode is available only if impermanence is enabled. This ensures that
> activity under Nomad Mode does not affect the standard system.

> **Does this clutter my device?** No, all GNOME-specific things (except some
> logs) are thrown out by impermanence.

The configuration for nomad mode is
[here](../../modules/laptop/modes/nomad.nix).

You cannot use the `nixos` script from within the nomad specialisation.
