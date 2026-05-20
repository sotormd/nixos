{ self, ... }:

let
  inherit (self.nixosModules.modules) apps services sway;
in
{
  imports = [
    apps.brave
    apps.dev
    apps.file-roller
    apps.foot
    apps.git
    apps.i2p-browser
    apps.inkscape
    apps.mousepad
    apps.mpv
    apps.neovim
    apps.sandbox
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
