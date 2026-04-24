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
  nixpkgs.overlays = [
    (_: _: { dunst0 = package.dunstWrapped; })
    (_: _: { volume0 = scripts.volume; })
    (_: _: { brightness0 = scripts.brightness; })
    (_: _: { media0 = scripts.media; })
  ];
}
