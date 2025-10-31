{
  lib,
  pkgs,
  vars,
  ...
}:

{
  users.users.${vars.user.name}.packages = [ pkgs.sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
