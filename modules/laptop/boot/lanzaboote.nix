{
  inputs,
  lib,
  pkgs,
  vars,
  ...
}:

{
  # secure boot for nixos

  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  users.users.${vars.user.name}.packages = [ pkgs.sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
