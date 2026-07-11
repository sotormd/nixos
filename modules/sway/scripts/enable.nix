{ config, pkgs, ... }:

let
  scripts = pkgs.callPackage ./scripts.nix { };
in
{
  users.users.${config.vars.user.name}.packages = [
    scripts.volume
    scripts.brightness
    scripts.media
  ];
  nixpkgs.overlays = [
    (_: _: { volume0 = scripts.volume; })
    (_: _: { brightness0 = scripts.brightness; })
    (_: _: { media0 = scripts.media; })
  ];
}
