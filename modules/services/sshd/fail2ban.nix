{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.ssh.enable {
    services.fail2ban = {
      enable = true;
      maxretry = 2;
      bantime = "24h";
      bantime-increment = {
        enable = true;
        multipliers = "1 2 4 8 16 32 64 128 256";
        maxtime = "6144h";
        overalljails = true;
      };
    };
    systemd.tmpfiles.rules = [
      "d /var/lib/fail2ban 700 root root -"
      "Z /var/lib/fail2ban - root root -"
    ];
  };
}
