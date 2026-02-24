{ config, ... }:

{
  imports = [
    ./address.nix

    ./settings.nix
  ];

  # enable unbound validating recursive dns server
  services.unbound.enable = config.vars.services.unbound.enable;
}
