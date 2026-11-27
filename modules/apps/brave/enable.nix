{
  config,
  inputs,
  pkgs,
  ...
}:

let
  preferences = pkgs.callPackage ./preferences.nix { };
  executable = pkgs.callPackage ./executable.nix { inherit preferences; };
  homepage = pkgs.callPackage ./home.nix { inherit (config) vars; };
  policies = pkgs.callPackage ./policies.nix {
    inherit homepage;
    inherit (config) vars;
  };
  state = pkgs.callPackage ./state.nix { };
  jail = pkgs.callPackage ./bubblewrap.nix {
    inherit
      inputs
      executable
      policies
      state
      ;
    inherit (config) vars;
  };
  logger = pkgs.callPackage ./logger.nix { inherit jail; };
  package = pkgs.callPackage ./package.nix { inherit executable logger; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
  nixpkgs.overlays = [ (_: _: { brave0 = package; }) ];
}
