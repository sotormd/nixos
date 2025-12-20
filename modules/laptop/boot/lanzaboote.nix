{
  inputs,
  lib,
  pkgs,
  vars,
  ...
}:

{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  users.users.${vars.user.name}.packages = [ pkgs.sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
