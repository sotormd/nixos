{ config, pkgs, ... }:

{
  imports = [
    ./engines.nix

    ./nginx.nix

    ./settings.nix

    ./sops.nix

    ./uwsgi.nix
  ];

  services.searx.enable = config.vars.services.searxng.enable;
  services.searx.package = pkgs.searxng;
}
