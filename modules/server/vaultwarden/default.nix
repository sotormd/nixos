{ config, ... }:

{
  imports = [
    ./nginx.nix

    ./settings.nix
  ];

  services.vaultwarden.enable = config.vars.services.vaultwarden.enable;
}
