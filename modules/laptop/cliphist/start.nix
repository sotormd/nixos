{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    wayland.windowManager.sway.config.keybindings = {
      "Mod4+c" = "exec cliphist list | rofi -dmenu -p '' | cliphist decode | wl-copy";
      "ctrl+Mod4+c" = "exec cliphist wipe";
    };
  };
}
