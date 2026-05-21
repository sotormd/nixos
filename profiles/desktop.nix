{ self, ... }:

let
  inherit (self.nixosModules.modules) apps services sway;
in
{
  imports = [
    apps.brave
    apps.file-roller
    apps.foot
    apps.i2p-browser
    apps.inkscape
    apps.mousepad
    apps.mpv
    apps.neovim
    apps.thunar
    apps.zathura
    services.pipewire
    sway.cage
    sway.dunst
    sway.eww
    sway.gtk
    sway.packages
    sway.rofi
    sway.swaylock
    sway.swaywm
    sway.waybar
  ];
}
