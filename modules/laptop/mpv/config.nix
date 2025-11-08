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
in
{
  configDir = pkgs.symlinkJoin {
    name = "config";
    paths = [ config ];
  };
}
