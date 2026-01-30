{ config, lib, ... }:

let
  modes = [ "nomad" ];

  mkSpec = mode: {
    inheritParentConfig = false;
    configuration = {

      # everything needed for a clean, base system
      imports = [
        ../../../vars-schema/common.nix
        ../../../vars-schema/laptop.nix
        ../../common
        ../audio
        ../boot
        ../impermanence
        ../network
        ../sops
        ../ssh
        ../users
        ../virtualization
        ./${mode}.nix
      ];

      vars.nixosRole = lib.mkForce "laptop-mode";

      system.stateVersion = "24.05";
    };
  };
in
{
  # enable mode specialisations only if impermanence is enabled
  config = lib.mkIf config.vars.device.impermanence.enable {
    specialisation = lib.genAttrs modes mkSpec;
  };
}
