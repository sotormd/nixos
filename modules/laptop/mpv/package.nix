{ pkgs, ... }:

let
  config = import ./config.nix { inherit pkgs; };
  mpvWrapped = pkgs.writeShellScriptBin "mpv" ''
    ${pkgs.mpv}/bin/mpv --config-dir=${config.configDir} "$@"
  '';
in
{
  mpv = pkgs.symlinkJoin {
    name = "mpv";
    paths = [ pkgs.mpv ];

    # replace the mpv binary with our wrapper
    postBuild = ''
      rm -f $out/bin/mpv
      ln -s ${mpvWrapped}/bin/mpv $out/bin/mpv
    '';
  };
}
