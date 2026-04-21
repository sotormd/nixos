{ config, ... }:

{
  hjem.users.${config.vars.user.name} = {
    files.".config/Thunar/uca.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <actions>
      <action>
              <icon>utilities-terminal</icon>
              <name>Open Terminal Here</name>
              <submenu></submenu>
              <unique-id>1733803391826120-1</unique-id>
              <command>foot -D %f</command>
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
