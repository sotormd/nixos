{ pkgs, ... }:

let
  config = pkgs.writeTextFile {
    name = "btop.conf";
    text = ''
      color_theme = "nord"
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
    #! ${pkgs.runtimeShell}

    ${pkgs.btop}/bin/btop --config ${configDir}/btop.conf "$@"
  '';
}
