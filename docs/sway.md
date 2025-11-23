# sway

Interacting with the sway window manager

Use `Mod4+Shift+slash` or `Mod4+?` to open this file

# Contents

- [Keybindings](#keybindings)
  - [**Workspace Management**](#workspace-management)
  - [**Window Movement & Focus**](#window-movement-focus)
  - [**Window Layout & Modes**](#window-layout-modes)
  - [**Resize Mode**](#resize-mode-mod4r)
  - [**Applications & Launchers**](#applications-launchers)
  - [**Screenshots**](#screenshots-mod4print)
  - [**Media Controls**](#media-controls)
  - [**Brightness Controls**](#brightness-controls)
  - [**Opacity Controls**](#opacity-controls)
  - [**Leave Mode**](#leave-mode-mod4escape-via-eww)
  - [**Clipboard (cliphist)**](#clipboard-cliphist)

## Keybindings

### **Workspace Management**

| Keybinding        | Description                                                    |
| ----------------- | -------------------------------------------------------------- |
| `Mod4+1..0`       | Switch to workspace 1–10 on the focused output                 |
| `Mod4+Shift+1..0` | Move focused container to workspace 1–10 on the focused output |
| `Mod4+g`          | Switch to workspace via Rofi menu                              |
| `Mod4+Shift+g`    | Move container to workspace via Rofi menu                      |
| `Mod4+Page_Down`  | Next workspace                                                 |
| `Mod4+Page_Up`    | Previous workspace                                             |

### **Window Movement & Focus**

| Keybinding                        | Description          |
| --------------------------------- | -------------------- |
| `Mod4+Down / Mod4+j`              | Focus down           |
| `Mod4+Up / Mod4+k`                | Focus up             |
| `Mod4+Left / Mod4+h`              | Focus left           |
| `Mod4+Right / Mod4+l`             | Focus right          |
| `Mod4+a`                          | Focus parent         |
| `Mod4+Shift+Down / Mod4+Shift+j`  | Move container down  |
| `Mod4+Shift+Up / Mod4+Shift+k`    | Move container up    |
| `Mod4+Shift+Left / Mod4+Shift+h`  | Move container left  |
| `Mod4+Shift+Right / Mod4+Shift+l` | Move container right |

### **Window Layout & Modes**

| Keybinding         | Description               |
| ------------------ | ------------------------- |
| `Mod4+e`           | Toggle split layout       |
| `Mod4+s`           | Set stacking layout       |
| `Mod4+w`           | Set tabbed layout         |
| `Mod4+f`           | Toggle fullscreen         |
| `Mod4+space`       | Toggle focus mode         |
| `Mod4+Shift+space` | Toggle floating mode      |
| `Mod4+minus`       | Show scratchpad           |
| `Mod4+Shift+minus` | Move window to scratchpad |
| `Mod4+r`           | Enter resize mode         |

### **Resize Mode** (`Mod4+r`)

| Keybinding        | Description        |
| ----------------- | ------------------ |
| `h / Left`        | Shrink width 10px  |
| `l / Right`       | Grow width 10px    |
| `j / Down`        | Grow height 10px   |
| `k / Up`          | Shrink height 10px |
| `Escape / Return` | Exit resize mode   |

### **Applications & Launchers**

| Keybinding       | Description              |
| ---------------- | ------------------------ |
| `Mod4+Return`    | Launch terminal (`foot`) |
| `Mod4+backslash` | Launch browser (`brave`) |
| `Mod4+d`         | Launch `rofi -show run`  |
| `Mod4+Tab`       | Toggle dock (eww)        |
| `Mod4+grave`     | Toggle start menu (eww)  |

### **Screenshots** (`Mod4+Print`)

| Keybinding | Description                  |
| ---------- | ---------------------------- |
| `c`        | Copy screenshot to clipboard |
| `s`        | Save screenshot              |
| `p`        | Pick color under cursor      |
| `w`        | Copy window                  |
| `a`        | Copy area                    |

### **Media Controls**

| Keybinding             | Description                      |
| ---------------------- | -------------------------------- |
| `Mod4+XF86AudioPlay`   | Stop media via `playerctl`       |
| `XF86AudioPlay`        | Play/pause media via `playerctl` |
| `XF86AudioNext`        | Next track via `playerctl`       |
| `XF86AudioPrev`        | Previous track via `playerctl`   |
| `XF86AudioLowerVolume` | Lower volume 5% via `wpctl`      |
| `XF86AudioRaiseVolume` | Raise volume 5% via `wpctl`      |
| `XF86AudioMute`        | Toggle mute via `wpctl`          |

### **Brightness Controls**

| Keybinding              | Description                                |
| ----------------------- | ------------------------------------------ |
| `XF86MonBrightnessUp`   | Increase brightness 5% via `brightnessctl` |
| `XF86MonBrightnessDown` | Decrease brightness 5% via `brightnessctl` |

### **Opacity Controls**

| Keybinding | Description            |
| ---------- | ---------------------- |
| `Mod4+t`   | Set window opacity 0.9 |
| `Mod4+o`   | Set window opacity 1   |

### **Leave Mode** (`Mod4+Escape / via eww`)

| Keybinding | Description                             |
| ---------- | --------------------------------------- |
| `Escape`   | Exit leave mode                         |
| `Return`   | Exit leave mode                         |
| `l`        | Lock screen (`swaylock`)                |
| `r`        | Reboot system (`systemctl reboot`)      |
| `s`        | Suspend system (`systemctl suspend`)    |
| `u`        | Power off system (`systemctl poweroff`) |
| `x`        | Exit Sway (`swaymsg exit`)              |

### **Clipboard (cliphist)**

| Keybinding    | Description                           |
| ------------- | ------------------------------------- |
| `Mod4+c`      | Open cliphist menu and copy selection |
| `Mod4+Ctrl+c` | Wipe cliphist                         |
