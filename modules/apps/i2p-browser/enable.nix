{
  config,
  pkgs,
  lib,
  ...
}:

let
  policies = import ./policies.nix;
  executable = pkgs.callPackage ./executable.nix { inherit policies; };
  profile = pkgs.callPackage ./profile.nix { inherit (config) vars; };
  script = pkgs.callPackage ./script.nix { inherit executable profile; };
  jail = pkgs.callPackage ./bubblewrap.nix {
    inherit script;
    inherit (config) vars;
  };
  desktop = pkgs.callPackage ./desktop.nix { };
  package = pkgs.callPackage ./package.nix { inherit jail desktop; };
in
lib.mkIf config.vars.selfhosted.i2pd.enable {

  users.users.${config.vars.user.name}.packages = [ package ];

}
