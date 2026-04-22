{
  config,
  lib,
  pkgs,
  ...
}:

{
  # secure boot for nixos

  config = lib.mkIf config.vars.features.secureboot.enable {

    environment.systemPackages = [ pkgs.sbctl ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

  };
}
