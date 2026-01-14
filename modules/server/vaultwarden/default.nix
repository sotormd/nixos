{ config, ... }:

{
  imports = [
    ./nginx.nix

    ./settings.nix
  ];

  services.vaultwarden.enable = config.vars.network.vaultwarden.enable;
}
