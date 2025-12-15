{ colors, pkgs, ... }:

let
  config = pkgs.writeTextFile {
    name = "btop.conf";
    text = ''
      color_theme = "${colors.btop}"
    '';
    destination = "/btop.conf";
  };

  configDir = pkgs.symlinkJoin {
    name = "btop";
    paths = [ config ];
  };
in
{
  btop = pkgs.writeShellScriptBin "btop" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.btop}/bin/btop --config ${configDir}/btop.conf "$@"
  '';
}
