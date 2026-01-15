{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  # secure boot for nixos

  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  config = lib.mkIf config.vars.device.secureboot.enable {

    environment.systemPackages = [ pkgs.sbctl ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

  };
}
