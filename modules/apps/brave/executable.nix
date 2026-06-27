{ brave, preferences, ... }:

let
  commandLineArgs = [ ];

  executable =
    (brave.overrideAttrs (oldAttrs: {
      installPhase =
        oldAttrs.installPhase
        + "cp ${preferences}/initial_preferences $out/opt/brave.com/brave/initial_preferences";
    })).override
      { inherit commandLineArgs; };
in
executable
