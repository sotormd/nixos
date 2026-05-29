{ config, lib, ... }:

{
  options = {
    remote = {
      sshKey = lib.mkOption { type = lib.types.str; };
      wireless = {
        interface = lib.mkOption { type = lib.types.str; };
        ssid = lib.mkOption { type = lib.types.str; };
        psk = lib.mkOption { type = lib.types.str; };
        gateway = lib.mkOption { type = lib.types.str; };
        address = lib.mkOption { type = lib.types.str; };
      };
    };
  };

  config = {

    services.openssh.enable = true;
    services.openssh.settings = {
      PubkeyAuthentication = true;
      AuthenticationMethods = "publickey";
      PasswordAuthentication = false;
      PermitEmptyPasswords = false;
    };
    users.users.nixos.openssh.authorizedKeys.keys = [ config.remote.sshKey ];

    networking = {
      networkmanager.enable = lib.mkOverride 10 false;

      wireless = {
        enable = true;
        userControlled = true;
        networks.${config.remote.wireless.ssid}.psk = config.remote.wireless.psk;
        interfaces = [ config.remote.wireless.interface ];
      };

      dhcpcd.enable = false;
      useDHCP = false;

      defaultGateway = config.remote.wireless.gateway;

      interfaces.${config.remote.wireless.interface}.ipv4.addresses = [
        {
          address = config.remote.wireless.address;
          prefixLength = 24;
        }
      ];

      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };

  };
}
