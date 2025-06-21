{ vars, ... }:

{
  services.vaultwarden.backupDir = null;

  services.vaultwarden.config = {
    WEB_VAULT_ENABLED = true;
    DOMAIN = "https://${vars.network.duckdns.domain}/vaultwarden";
    ROCKET_ADDRESS = "127.0.0.1";
    ROCKET_PORT = vars.network.vaultwarden.port;
    SENDS_ALLOWED = false;
    SIGNUPS_ALLOWED = false;
    SIGNUPS_VERIFY = false;
    PASSWORD_HINTS_ALLOWED = false;
    EXTENDED_LOGGING = true;
    USE_SYSLOG = true;
  };

  # use bind mounts for a custom DATA_FOLDER
  # services.vaultwarden.DATA_FOLDER isnt honoured (?)
  fileSystems."/var/lib/bitwarden_rs" = {
    device = "${vars.network.vaultwarden.data}";
    options = [ "bind" ];
  };
}
