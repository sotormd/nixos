{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };
  rofiWrapped = pkgs.writeShellScriptBin "rofi" ''
    ${pkgs.rofi}/bin/rofi -config ${configuration.config}/config.rasi "$@"
  '';
in
{
  rofi = pkgs.symlinkJoin {
    name = "rofi";
    paths = [ pkgs.rofi ];

    # replace the rofi binary with our wrapper
    postBuild = ''
      rm -f $out/bin/rofi
      ln -s ${rofiWrapped}/bin/rofi $out/bin/rofi
    '';
  };
}
