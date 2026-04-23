{ config, pkgs, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";

  xfconf = pkgs.writeText "thunar.xml" ''
    <?xml version="1.1" encoding="UTF-8"?>

    <channel name="thunar" version="1.0">
      <property name="TerminalEmulator" type="string" value="foot"/>
      <property name="last-icon-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_100_PERCENT"/>
      <property name="last-menubar-visible" type="bool" value="false"/>
      <property name="last-separator-position" type="int" value="170"/>
      <property name="last-statusbar-visible" type="bool" value="false"/>
      <property name="last-toolbar-item-order" type="string" value="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17"/>
      <property name="last-toolbar-visible-buttons" type="string" value="1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0"/>
      <property name="last-view" type="string" value="ThunarIconView"/>
      <property name="last-window-height" type="int" value="1030"/>
      <property name="last-window-maximized" type="bool" value="false"/>
      <property name="last-window-width" type="int" value="1902"/>
    </channel>
  '';
in
{
  programs.xfconf.enable = true;

  systemd.tmpfiles.rules = [
    "L ${home}/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml - - - - ${xfconf}"
  ];
}
