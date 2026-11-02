{ pkgs, ... }:

{
  systemd.user.services.pantheon-dconf = {
    enable = true;
    description = "Apply Pantheon dconf settings at login";
    after = [ "graphical.target" ];
    wantedBy = [ "default.target" ];
    path = [ pkgs.dconf ];
    script = ''
      dconf write /org/gnome/desktop/background/picture-uri "'file:///run/current-system/sw/share/backgrounds/odin.jpg'"
    '';
    serviceConfig.Type = "oneshot";
  };
}
