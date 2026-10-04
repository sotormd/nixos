{
  config,
  inputs,
  pkgs,
  ...
}:

let
  package = inputs.emacs.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
  nixpkgs.overlays = [ (_: _: { emacs0 = package; }) ];
}
