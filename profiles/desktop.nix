{ inputs, ... }:

let
  m = inputs.self.nixosModules.modules;
in
{
  imports = [
    m.apps.brave
    m.apps.btop
    m.apps.dev
    m.apps.distrobox
    m.apps.foot
    m.apps.i2p-browser
    m.apps.inkscape
    m.apps.mousepad
    m.apps.mpv
    m.apps.neovim
    m.apps.sandbox
    m.apps.thunar
    m.apps.zathura
    m.services.libvirtd
    m.services.pipewire
    m.sway.dunst
    m.sway.eww
    m.sway.gtk
    m.sway.packages
    m.sway.rofi
    m.sway.swaylock
    m.sway.swaywm
    m.sway.waybar
  ];
}
