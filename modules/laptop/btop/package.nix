{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };

  btopWrapped = pkgs.writeShellScriptBin "btop" ''
    ${pkgs.btop}/bin/btop --config ${configuration.configDir}/btop.conf "$@"
  '';
in
{
  btop = pkgs.symlinkJoin {
    name = "btop";
    paths = [ pkgs.btop ];

    # replace the btop binary with our wrapper
    postBuild = ''
      rm -f $out/bin/btop
      ln -s ${btopWrapped}/bin/btop $out/bin/btop
    '';
  };
}
