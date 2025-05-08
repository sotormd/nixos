{ vars, ... }:

{
  services.vaultwarden.backupDir = null;

  services.vaultwarden.config = {
    DATA_FOLDER = "${vars.network.vaultwarden.data}";
    WEB_VAULT_ENABLED = true;
    DOMAIN = "https://${vars.network.duckdns.domain}/vaultwarden";
    SENDS_ALLOWED = false;
    SIGNUPS_ALLOWED = true;
    SIGNUPS_VERIFY = false;
    PASSWORD_HINTS_ALLOWED = false;
    EXTENDED_LOGGING = true;
    USE_SYSLOG = true;
  };
}
