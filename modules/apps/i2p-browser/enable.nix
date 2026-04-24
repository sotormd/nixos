{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (import ./package.nix { inherit config pkgs; }) i2pBrowser;
in
{
  config = lib.mkIf config.vars.selfhosted.i2pd.enable {
    users.users.${config.vars.user.name}.packages = [ i2pBrowser ];
  };
}
