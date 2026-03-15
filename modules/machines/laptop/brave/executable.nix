{ config, pkgs, ... }:

let
  preferences = import ./preferences.nix { inherit config pkgs; };
  args = import ./args.nix;

  executable =
    (pkgs.brave.overrideAttrs (oldAttrs: {
      installPhase =
        oldAttrs.installPhase
        + "cp ${preferences.preferencesFile} $out/opt/brave.com/brave/initial_preferences";
    })).override
      { inherit (args) commandLineArgs; };
in
{
  inherit executable;
}
