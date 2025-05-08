{ home-manager, vars, ... }:

let
  # configuration at '~/.config/BraveSoftware/Brave-Browser/Local State'
  localState = {
    # disable telemetry
    brave.p3a.enabled = false;
    brave.stats.reporting_enabled = false;
    user_experience_metrics.reporting_enabled = false;
  };
in
{
  home-manager.users."${vars.user.name}" = {
    home.file.".config/BraveSoftware/Brave-Browser/Local State" = {
      text = builtins.toJSON localState;
      force = true;
    };
  };
}
