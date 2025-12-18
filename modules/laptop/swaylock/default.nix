{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let
  package = import ./package.nix {
    inherit
      config
      lib
      pkgs
      vars
      ;
  };
in
{
  imports = lib.concatMap (x: x) [
    [
      ./settings.nix
    ]

    (lib.optional (builtins.substring 0 4 vars.outputs.lockscreen == "xkcd") ./xkcd.nix)
  ];

  users.users.${vars.user.name}.packages = [ package.swaylock ];
}
