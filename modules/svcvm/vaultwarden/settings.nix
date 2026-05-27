{ config, ... }:

let
  inherit (config.svcfg) vaultwarden;
in
{
  services.vaultwarden = {

    # enable the vaultwarden password manager
    enable = true;

    # manage backups externally
    backupDir = null;

    config = {
      WEB_VAULT_ENABLED = true;
      ROCKET_ADDRESS = vaultwarden.address;
      ROCKET_PORT = vaultwarden.port;
      DOMAIN = "https://${vaultwarden.domain}/vaultwarden";
      SENDS_ALLOWED = false;
      SIGNUPS_ALLOWED = vaultwarden.signups;
      SIGNUPS_VERIFY = false;
      PASSWORD_HINTS_ALLOWED = false;
      EXTENDED_LOGGING = true;
      USE_SYSLOG = true;
    };
  };

  systemd.services = {

    # start after appropriate indicators
    vaultwarden = {
      wants = [
        "network-online.target"
        "svcready-interface.service"
      ];
      after = [
        "network-online.target"
        "svcready-interface.service"
      ];
    };

    # we dont need internet
    svcready-resolve.enable = false;

  };

  # ensure appropriate permissions on data directories
  systemd.tmpfiles.rules = [
    "d /var/lib/bitwarden_rs 700 vaultwarden vaultwarden -"
    "Z /var/lib/bitwarden_rs 700 vaultwarden vaultwarden -"
  ];

  # ensure appropriate uid/gid
  users.users.vaultwarden = {
    uid = vaultwarden.id;
    group = "vaultwarden";
  };
  users.groups.vaultwarden = {
    gid = vaultwarden.id;
  };
}
