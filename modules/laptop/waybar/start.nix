{
  lib,
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  # start waybar in sway
  home-manager.users."${vars.user.name}" = {
    wayland.windowManager.sway.config = {
      bars = lib.mkForce [ ];
      startup = [
        {
          command = ''
            ${pkgs.waybar}/bin/waybar
          '';
        }
      ];
    };
  };
}
