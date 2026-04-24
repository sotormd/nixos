{ config, lib, ... }:

{
  # secure boot for nixos

  config = lib.mkIf config.vars.features.secureboot.enable {

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

  };
}
