{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.vaultwarden.enable {

    services.vaultwarden.backupDir = null;

    services.vaultwarden.config = {
      WEB_VAULT_ENABLED = true;
      DOMAIN = "https://${config.vars.services.nginx.domain}/vaultwarden";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      SENDS_ALLOWED = false;
      SIGNUPS_ALLOWED = false;
      SIGNUPS_VERIFY = false;
      PASSWORD_HINTS_ALLOWED = false;
      EXTENDED_LOGGING = true;
      USE_SYSLOG = true;
    };

  };
}
