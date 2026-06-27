{ writeTextFile, ... }:

let
  configuration = writeTextFile {
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
configuration
