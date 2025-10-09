{
  lib,
  pkgs,
  vars,
  ...
}:

{
  home-manager.users.${vars.user.name}.home.packages = [ pkgs.sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
