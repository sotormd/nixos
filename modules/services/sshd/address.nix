{ config, lib, ... }:

let
  inherit (config.vars.services) ssh;
  inherit (config.vars) network;
in
lib.mkIf ssh.enable {

  services.openssh = {

    # ssh address
    settings.ListenAddress =
      if network.wireless.enable then
        network.wireless.address
      else if network.hostapd.enable then
        network.hostapd.address
      else
        "0.0.0.0";

    # ssh port
    ports = lib.mkForce [ ssh.port ];

    # do not automatically open the ports
    openFirewall = false;

  };

}
