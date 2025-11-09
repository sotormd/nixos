{ pkgs, vars, ... }:

{
  hjem.users.${vars.user.name} = {
    files.".local/share/themes/Nordic-darker".source = "${pkgs.nordic}/share/themes/Nordic-darker";

    files.".local/share/icons/Nordzy-dark".source = "${pkgs.nordzy-icon-theme}/share/icons/Nordzy-dark";

    files.".local/share/fonts/ibm-plex".source = "${pkgs.ibm-plex}/share/fonts/opentype";
    files.".local/share/fonts/nerdfonts-im-writer".source =
      "${pkgs.nerd-fonts.im-writing}/share/fonts/truetype/NerdFonts/iMWriting";
    files.".local/share/fonts/noto-fonts-color-emoji".source =
      "${pkgs.noto-fonts-color-emoji}/share/fonts/noto";

    files.".icons/Simp1e-Nord-Dark".source = "${pkgs.simp1e-cursors}/share/icons/Simp1e-Nord-Dark";

    files.".Xresources".text = ''
      Xcursor.size: 1
      Xcursor.theme: Simp1e-Nord-Dark
    '';

    files.".gtkrc-2.0".text = ''
      gtk-cursor-theme-name = "Simp1e-Nord-Dark"
      gtk-cursor-theme-size = 1
      gtk-font-name = "IBM Plex Sans 10"
      gtk-icon-theme-name = "Nordzy-dark"
      gtk-theme-name = "Nordic-darker"
    '';

    files.".icons/default/index.theme".text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=Simp1e-Nord-Dark
    '';

    files.".config/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-theme-name=Simp1e-Nord-Dark
      gtk-cursor-theme-size=1
      gtk-font-name=IBM Plex Sans 10
      gtk-icon-theme-name=Nordzy-dark
      gtk-theme-name=Nordic-darker
    '';

    files.".config/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-theme-name=Simp1e-Nord-Dark
      gtk-cursor-theme-size=1
      gtk-font-name=IBM Plex Sans 10
      gtk-icon-theme-name=Nordzy-dark
      gtk-theme-name=Nordic-darker
    '';

    files.".config/gtk-4.0/gtk.css".text = ''
      /**
       * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
       * It does however respect user CSS, so import the theme from here.
      **/
      @import url("file://${pkgs.nordic}/share/themes/Nordic-darker/gtk-4.0/gtk.css");
    '';
  };
}
