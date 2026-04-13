{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ./config.nix { inherit config lib pkgs; }) configuration;

  swaylockWrapperScript = pkgs.writeTextFile {
    name = "swaylock-wrapper-script";
    text = ''
      #!${pkgs.runtimeShell}

      ${pkgs.swaylock}/bin/swaylock --config ${configuration}/config "$@"
      ${pkgs.xkcd0}/bin/xkcd-refresh
    '';
    destination = "/bin/swaylock";
    executable = true;
  };

  swaylockWrapped = pkgs.symlinkJoin {
    name = "swaylock-wrapped";
    paths = [ pkgs.swaylock ];

    # replace the swaylock binary with our wrapper
    postBuild = ''
      rm -f $out/bin/swaylock
      ln -s ${swaylockWrapperScript}/bin/swaylock $out/bin/swaylock
    '';
  };
in
{
  inherit swaylockWrapped;
}
