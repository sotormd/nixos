{ config, pkgs, ... }:

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

  # start after appropriate indicators
  systemd.services.vaultwarden = {
    wants = config.svcready.units;
    after = config.svcready.units;
  };
  svcready = {
    interface.enable = true;
  };

  # ensure appropriate permissions on data directories
  systemd.services.fix-vaultwarden-perms = {
    wantedBy = [ "multi-user.target" ];
    after = [ "var-lib-bitwarden_rs.mount" ];
    before = [ "vaultwarden.service" ];
    path = [
      pkgs.coreutils
      pkgs.findutils
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /var/lib/bitwarden_rs
      find /var/lib/bitwarden_rs -type d -exec chmod 700 {} +
      find /var/lib/bitwarden_rs -type f -exec chmod 600 {} +
      chown -R vaultwarden:vaultwarden /var/lib/bitwarden_rs
    '';
  };

  # ensure appropriate uid/gid
  users.users.vaultwarden = {
    uid = vaultwarden.id;
    group = "vaultwarden";
  };
  users.groups.vaultwarden = {
    gid = vaultwarden.id;
  };
}
