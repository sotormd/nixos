{
  lib,
  pkgs,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}".home.packages = [ pkgs.sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce (!vars.features.secureboot.enabled);

  boot.lanzaboote = {
    enable = vars.features.secureboot.enabled;
    pkiBundle = "/var/lib/sbctl";
  };
}
