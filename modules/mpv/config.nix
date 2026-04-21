{ pkgs, ... }:

let
  configuration = pkgs.writeTextFile {
    name = "mpv-config";
    text = ''
      hwdec=auto-safe
      vo=gpu
      profile=gpu-hq
      gpu-context=wayland
    '';
    destination = "/mpv.conf";
    executable = false;
  };
in
{
  inherit configuration;
}
