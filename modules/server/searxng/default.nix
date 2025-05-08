{ pkgs, ... }:

{
  imports = [
    ./engines.nix

    ./nginx.nix

    ./settings.nix

    ./uwsgi.nix
  ];

  services.searx.enable = true;
  services.searx.package = pkgs.searxng;
}
