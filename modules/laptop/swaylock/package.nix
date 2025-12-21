{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let
  configuration = import ./config.nix {
    inherit
      config
      lib
      pkgs
      vars
      ;
  };
  swaylockWrapped = pkgs.writeShellScriptBin "swaylock" (
    lib.concatStringsSep "\n" (
      lib.concatMap (x: x) [
        [ ''${pkgs.swaylock}/bin/swaylock --config ${configuration.configDir}/config "$@"'' ]
        (lib.optional (
          builtins.substring 0 4 vars.outputs.lockscreen == "xkcd"
        ) "systemctl restart xkcd-wall.service --user || echo 1")
      ]
    )
  );
in
{
  swaylock = pkgs.symlinkJoin {
    name = "swaylock";
    paths = [ pkgs.swaylock ];

    # replace the swaylock binary with our wrapper
    postBuild = ''
      rm -f $out/bin/swaylock
      ln -s ${swaylockWrapped}/bin/swaylock $out/bin/swaylock
    '';
  };
}
