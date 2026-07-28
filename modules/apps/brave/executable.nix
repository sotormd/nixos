{ brave, preferences, ... }:

let
  # 1. set initial_preferences
  # 2. make .desktop not use absolute path
  executable = brave.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      cp ${preferences}/initial_preferences \
        $out/opt/brave.com/brave/initial_preferences

      sed -Ei \
       's|/nix/store/[^ ]*/bin/brave|brave|g' \
        $out/share/applications/brave-browser.desktop
    '';
  });
in
executable
