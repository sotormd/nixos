{ pkgs, ... }:

let
  scripts = import ./scripts.nix { inherit pkgs; };
in
{

  config = pkgs.writeTextFile {
    name = "config";
    text = builtins.readFile (
      pkgs.replaceVars ./config/config.json {
        playerctlScript = "${scripts.scriptsDir}/playerctl.sh";
        muteScript = "${scripts.scriptsDir}/mute.sh";
        animationScript = "${scripts.scriptsDir}/animation.sh";
        namespacesStatusScript = "${scripts.scriptsDir}/namespaces-status.sh";
        namespacesToggleScript = "${scripts.scriptsDir}/namespaces-toggle.sh";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        jq = "${pkgs.jq}/bin/jq";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
      }
    );
    destination = "/config";
  };
}
