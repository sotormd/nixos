{ config, ... }:

{
  imports = [
    ./nginx.nix

    ./service.nix
  ];

  services.jellyfin.enable = config.vars.services.jellyfin.enable;
}
