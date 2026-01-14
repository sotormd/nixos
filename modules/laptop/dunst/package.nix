{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };
  dunstWrapped = pkgs.writeShellScriptBin "dunst" ''
    ${pkgs.dunst}/bin/dunst -config ${configuration.configDir}/dunstrc "$@"
  '';
in
{
  dunst = pkgs.symlinkJoin {
    name = "dunst";
    paths = [ pkgs.dunst ];

    # replace the dunst binary with our wrapper
    postBuild = ''
      rm -f $out/bin/dunst
      ln -s ${dunstWrapped}/bin/dunst $out/bin/dunst
    '';
  };
}
