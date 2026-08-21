{
  self,
  config,
  lib,
  ...
}:

{
  imports = [ self.nixosModules.modules.network.networkmanager ];

  networking.nftables.ruleset = lib.mkOverride 10 ''
      table inet filter {
        chain input {
          type filter hook input priority filter; policy drop;
          ct state invalid drop
          tcp flags & (fin | syn | rst | ack) != syn ct state new drop
          ct state established,related accept
          iifname "lo" ct state new accept
          iifname "virbr*" tcp dport 53 ct state new accept
          iifname "virbr*" udp dport 53 ct state new accept
          iifname "virbr*" udp dport 67 ct state new accept
      }

      chain output {
        type filter hook output priority filter; policy drop;
        ct state invalid drop
        ct state new,established,related accept
      }
    }
  '';

  networking.wireless.enable = true;
  networking.wireless.userControlled = true;
  users.users.${config.vars.user.name}.extraGroups = [
    "wpa_supplicant"
    "networkmanager"
  ];

  systemd.network.networks = lib.mkForce { };
  networking.wireless.networks = lib.mkForce { };

  vars = {
    network = {
      resolver = lib.mkForce "1.1.1.1";
      wireless.enable = lib.mkForce true;
      wireguard.enable = lib.mkForce false;
      wired.enable = lib.mkForce false;
    };
    selfhosted = {
      searxng.enable = lib.mkForce false;
      vaultwarden.enable = lib.mkForce false;
      i2pd.enable = lib.mkForce false;
      qbt.enable = lib.mkForce false;
    };
  };
}
