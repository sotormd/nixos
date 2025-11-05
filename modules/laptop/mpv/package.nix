{ pkgs, ... }:

let
  config = pkgs.writeTextFile {
    name = "mpv.conf";
    text = ''
      hwdec=auto-safe
      vo=gpu
      profile=gpu-hq
      gpu-context=wayland
    '';
    destination = "/mpv.conf";
  };

  configDir = pkgs.symlinkJoin {
    name = "config";
    paths = [ config ];
  };
in
{
  mpv = pkgs.writeShellScriptBin "mpv" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.mpv}/bin/mpv --config-dir=${configDir} "$@"
  '';
}
