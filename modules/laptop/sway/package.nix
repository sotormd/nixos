{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let
  configuration = import ./config.nix {
    inherit
      config
      lib
      pkgs
      vars
      ;
  };
  swayWrapped = pkgs.writeShellScriptBin "sway" ''
    ${pkgs.swayfx}/bin/sway --config ${configuration.configDir}/config "$@"
  '';
in
{
  sway = pkgs.symlinkJoin {
    name = "sway";
    paths = [ pkgs.swayfx ];

    # replace the sway binary with our wrapper
    postBuild = ''
      rm -f $out/bin/sway
      ln -s ${swayWrapped}/bin/sway $out/bin/sway
    '';
  };
}
