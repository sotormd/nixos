{ config, pkgs, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";

  uca = pkgs.writeText "uca.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
    <action>
            <icon>utilities-terminal</icon>
            <name>Open Terminal Here</name>
            <submenu></submenu>
            <unique-id>1733803391826120-1</unique-id>
            <command>${pkgs.foot0}/bin/foot -D %f</command>
            <description>Open selected directory in terminal emulator</description>
            <range></range>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
    </action>
    </actions>
  '';
in
{
  systemd.tmpfiles.rules = [
    "d ${home}/.config 0700 ${user} ${user} -"
    "d ${home}/.config/Thunar 0700 ${user} ${user} - "
    "L ${home}/.config/Thunar/uca.xml - - - - ${uca}"
  ];
}
