{ pkgs, ... }:

{
  wayland.windowManager.sway.config.startup = [
    {
      command = ''
        ${pkgs.dunst}/bin/dunst
      '';
    }
  ];
}
