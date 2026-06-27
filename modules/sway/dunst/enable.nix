{ config, pkgs, ... }:

let
  configuration = pkgs.callPackage ./config.nix { inherit (config) colors vars; };
  package = pkgs.callPackage ./package.nix { inherit configuration; };
  scripts = pkgs.callPackage ./scripts.nix { };
in
{
  users.users.${config.vars.user.name}.packages = [
    package
    scripts.volume
    scripts.brightness
    scripts.media
    pkgs.libnotify
  ];
  nixpkgs.overlays = [
    (_: _: { dunst0 = package; })
    (_: _: { volume0 = scripts.volume; })
    (_: _: { brightness0 = scripts.brightness; })
    (_: _: { media0 = scripts.media; })
  ];
}
