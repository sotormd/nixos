{ pkgs, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    home.file.".config/Thunar/uca.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <actions>
      <action>
              <icon>utilities-terminal</icon>
              <name>Open Terminal Here</name>
              <submenu></submenu>
              <unique-id>1733803391826120-1</unique-id>
              <command>${pkgs.foot}/bin/foot -D %f</command>
              <description>Open selected directory in terminal emulator</description>
              <range></range>
              <patterns>*</patterns>
              <startup-notify/>
              <directories/>
      </action>
      </actions>
    '';
  };
}
