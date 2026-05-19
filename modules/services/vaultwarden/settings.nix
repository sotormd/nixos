{ config, lib, ... }:

let
  inherit (config.vars.services) nginx vaultwarden;
  inherit (lib.ports) internal;
in
{
  config = lib.mkIf vaultwarden.enable {

    services.vaultwarden.backupDir = null;

    services.vaultwarden.config = {
      WEB_VAULT_ENABLED = true;
      DOMAIN = "https://${nginx.domain}/vaultwarden";
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = internal.vaultwarden.webvault;
      SENDS_ALLOWED = false;
      SIGNUPS_ALLOWED = false;
      SIGNUPS_VERIFY = false;
      PASSWORD_HINTS_ALLOWED = false;
      EXTENDED_LOGGING = true;
      USE_SYSLOG = true;
    };

  };
}
