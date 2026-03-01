{ config, pkgs, ... }:

let
  inherit (import ./config.nix { inherit config pkgs; }) configuration;

  dunstWrapperScript = pkgs.writeTextFile {
    name = "dunst-wrapper-script";
    text = ''
      ${pkgs.dunst}/bin/dunst -config ${configuration}/dunstrc "$@"
    '';
    destination = "/bin/dunst";
    executable = true;
  };

  dunstWrapped = pkgs.symlinkJoin {
    name = "dunst-wrapped";
    paths = [ pkgs.dunst ];

    # replace the dunst binary with our wrapper
    postBuild = ''
      rm -f $out/bin/dunst
      ln -s ${dunstWrapperScript}/bin/dunst $out/bin/dunst
    '';
  };
in
{
  inherit dunstWrapped;
}
