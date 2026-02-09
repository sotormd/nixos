{
  config,
  pkgs,
  ...
}:

let
  preferences = import ./preferences.nix { inherit config pkgs; };
  args = import ./args.nix;
in
{
  customBrave =
    (pkgs.brave.overrideAttrs (oldAttrs: {
      installPhase =
        oldAttrs.installPhase
        + "cp ${preferences.preferencesFile} $out/opt/brave.com/brave/initial_preferences";
      postInstall =
        if (config.boot.kernel.sysctl."kernel.unprivileged_userns_clone" == "0") then
          (oldAttrs.postInstall or "")
          + "ln -sf /run/wrappers/bin/chrome-sandbox-brave $out/opt/brave.com/brave/chrome-sandbox"
        else
          (oldAttrs.postInstall or "");
    })).override
      { commandLineArgs = args.commandLineArgs; };
}
