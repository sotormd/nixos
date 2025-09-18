{ vars, ... }:

{
  # start waybar in sway
  home-manager.users."${vars.user.name}" = {
    wayland.windowManager.sway.config = {
      bars = [
        {
          command = "waybar";
          position = "top";
        }
      ];
    };
  };
}
