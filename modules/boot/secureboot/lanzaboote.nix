{ config, lib, ... }:

lib.mkIf config.vars.features.secureboot.enable {

  # secure boot for nixos
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;

}
