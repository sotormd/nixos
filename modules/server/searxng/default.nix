{ config, pkgs, ... }:

{
  imports = [
    ./engines.nix

    ./nginx.nix

    ./settings.nix

    ./uwsgi.nix
  ];

  services.searx.enable = config.vars.network.searxng.enable;
  services.searx.package = pkgs.searxng;
}
