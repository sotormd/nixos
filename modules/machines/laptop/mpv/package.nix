{ pkgs, ... }:

let
  inherit (import ./config.nix { inherit pkgs; }) configuration;

  mpvWrapperScript = pkgs.writeTextFile {
    name = "mpv-wrapper-script";
    text = ''
      #!${pkgs.runtimeShell}

      ${pkgs.mpv}/bin/mpv --config-dir=${configuration} "$@"
    '';
    destination = "/bin/mpv";
    executable = true;
  };

  mpvWrapped = pkgs.symlinkJoin {
    name = "mpv-wrapped";
    paths = [ pkgs.mpv ];

    # replace the mpv binary with our wrapper
    postBuild = ''
      rm -f $out/bin/mpv
      ln -s ${mpvWrapperScript}/bin/mpv $out/bin/mpv
    '';
  };
in
{
  inherit mpvWrapped;
}
