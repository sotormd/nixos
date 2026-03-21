{ config, pkgs, ... }:

let
  inherit (import ./preferences.nix { inherit config pkgs; }) preferences;
  inherit (import ./args.nix) commandLineArgs;

  executable =
    (pkgs.brave.overrideAttrs (oldAttrs: {
      installPhase =
        oldAttrs.installPhase
        + "cp ${preferences}/initial_preferences $out/opt/brave.com/brave/initial_preferences";
    })).override
      { inherit commandLineArgs; };
in
{
  inherit executable;
}
