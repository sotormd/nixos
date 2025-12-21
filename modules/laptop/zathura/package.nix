{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };

  zathuraWrapped = pkgs.writeShellScriptBin "zathura" ''
    ${pkgs.zathura}/bin/zathura --config-dir=${configuration.configDir} "$@"
  '';
in
{
  zathura = pkgs.symlinkJoin {
    name = "zathura";
    paths = [ pkgs.zathura ];

    # replace the zathura binary with our wrapper
    postBuild = ''
      rm -f $out/bin/zathura
      ln -s ${zathuraWrapped}/bin/zathura $out/bin/zathura
    '';
  };
}
