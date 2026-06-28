{
  brave,
  args,
  preferences,
  ...
}:

let
  executable =
    (brave.overrideAttrs (oldAttrs: {
      installPhase =
        oldAttrs.installPhase
        + "cp ${preferences}/initial_preferences $out/opt/brave.com/brave/initial_preferences";
    })).override
      { commandLineArgs = args; };
in
executable
