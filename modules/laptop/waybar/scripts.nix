{ pkgs, ... }:

let
  playerctlScript = pkgs.writeTextFile {
    name = "playerctl.sh";
    text = builtins.readFile (
      pkgs.replaceVars ./scripts/playerctl.sh {
        playerctl = "${pkgs.playerctl}/bin/playerctl";
      }
    );
    destination = "/playerctl.sh";
    executable = true;
  };

  muteScript = pkgs.writeTextFile {
    name = "mute.sh";
    text = builtins.readFile ./scripts/mute.sh;
    destination = "/mute.sh";
    executable = true;
  };

  animationScript = pkgs.writeTextFile {
    name = "animation.sh";
    text = builtins.readFile ./scripts/animation.sh;
    destination = "/animation.sh";
    executable = true;
  };

  namespacesStatusScript = pkgs.writeTextFile {
    name = "namespaces-status.sh";
    text = builtins.readFile ./scripts/namespaces-status.sh;
    destination = "/namespaces-status.sh";
    executable = true;
  };

  namespacesToggleScript = pkgs.writeTextFile {
    name = "namespaces-toggle.sh";
    text = builtins.readFile ./scripts/namespaces-toggle.sh;
    destination = "/namespaces-toggle.sh";
    executable = true;
  };
in
{
  scriptsDir = pkgs.symlinkJoin {
    name = "waybar-scripts";
    paths = [
      playerctlScript
      muteScript
      animationScript
      namespacesStatusScript
      namespacesToggleScript
    ];
  };
}
