{ pkgs, ... }:

let
  # configuration at '~/.config/BraveSoftware/Brave-Browser/Local State'
  localState = {
    # disable telemetry
    brave.p3a.enabled = false;
    brave.stats.reporting_enabled = false;
    user_experience_metrics.reporting_enabled = false;

    # disable shields highlight
    brave.onboarding.last_shields_icon_highlighted_time = "1";

    # enable widevine cdm
    brave.widevine_opted_in = true;
  };

  state = pkgs.writeTextFile {
    name = "brave-state";
    text = builtins.toJSON localState;
    destination = "/Local State";
    executable = false;
  };
in
{
  inherit state;
}
