{ config, lib, ... }:

{
  config = lib.mkIf config.vars.seed.enable {
    nix.settings.trusted-public-keys = config.vars.seed.trusted-keys;
  };
}
