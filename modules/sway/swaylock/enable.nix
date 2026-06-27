{
  config,
  inputs,
  pkgs,
  ...
}:

let
  configuration = pkgs.callPackage ./config.nix { inherit (config) colors vars; };
  package = pkgs.callPackage ./package.nix { inherit configuration; };
  xkcd = pkgs.callPackage ./xkcd.nix {
    inherit inputs;
    inherit (config) colors wallpapers vars;
  };
in
{
  users.users.${config.vars.user.name}.packages = [
    package
    xkcd
  ];
  nixpkgs.overlays = [
    (_: _: { swaylock0 = package; })
    (_: _: { xkcd0 = xkcd; })
  ];
}
