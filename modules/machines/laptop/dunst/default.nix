{ config, pkgs, ... }:

let
  package = import ./package.nix { inherit config pkgs; };
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  users.users.${config.vars.user.name}.packages = [
    package.dunstWrapped
    scripts.volume
    scripts.brightness
    scripts.media
    pkgs.libnotify
  ];
}
