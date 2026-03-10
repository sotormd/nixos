{ lib, ... }:

let
  key = builtins.getEnv "SSH_KEY";

  ssid = builtins.getEnv "WIFI_SSID";
  psk = builtins.getEnv "WIFI_PSK";
  gateway = builtins.getEnv "WIFI_GATEWAY";
  ip = builtins.getEnv "WIFI_IP";
in
{
  services.openssh.enable = true;
  users.users.nixos.openssh.authorizedKeys.keys = [ key ];

  networking = {
    networkmanager.enable = lib.mkForce false;
    wireless = {
      enable = true;
      userControlled = true;
      networks.${ssid}.psk = psk;
      interfaces = [ "wlan0" ];
    };
    dhcpcd.enable = false;
    useDHCP = false;
    defaultGateway = gateway;
    interfaces."wlan0".ipv4.addresses = [
      {
        address = ip;
        prefixLength = 24;
      }
    ];
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}
