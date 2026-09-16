{ writeTextFile }:

let
  configuration = writeTextFile {
    name = "mpv-configuration";
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
