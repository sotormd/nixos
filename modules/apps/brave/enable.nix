{
  config,
  inputs,
  pkgs,
  ...
}:

let
  preferences = pkgs.callPackage ./preferences.nix { inherit (config) colors; };
  homepage = pkgs.callPackage ./home.nix {
    inherit inputs;
    inherit (config) colors vars;
  };
  executable = pkgs.callPackage ./executable.nix { inherit preferences; };
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
  desktop = pkgs.callPackage ./desktop.nix { };
  package = pkgs.callPackage ./package.nix { inherit jail desktop; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
}
