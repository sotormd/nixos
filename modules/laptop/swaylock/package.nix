{
  config,
  lib,
  pkgs,
  ...
}:

let
  configuration = import ./config.nix {
    inherit
      config
      lib
      pkgs
      ;
  };
  swaylockWrapped = pkgs.writeShellScriptBin "swaylock" ''
    ${pkgs.swaylock}/bin/swaylock --config ${configuration.configDir}/config "$@"
    xkcd-refresh
  '';
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
