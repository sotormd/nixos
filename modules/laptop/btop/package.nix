{ config, pkgs, ... }:

let
  configuration = pkgs.writeTextFile {
    name = "btop.conf";
    text = ''
      color_theme = "${config.colors.btop}"
    '';
    destination = "/btop.conf";
  };

  configDir = pkgs.symlinkJoin {
    name = "btop";
    paths = [ configuration ];
  };
in
{
  btop = pkgs.writeShellScriptBin "btop" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.btop}/bin/btop --config ${configDir}/btop.conf "$@"
  '';
}
