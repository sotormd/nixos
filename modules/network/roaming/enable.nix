{ config, lib, ... }:

{
  config = lib.mkIf config.vars.features.impermanence.enable {
    specialisation = {
      roaming = import ./roaming.nix { inherit lib; };
    };
  };
}
