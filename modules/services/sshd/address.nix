{ config, lib, ... }:

let
  inherit (config.vars.services) ssh;
in
lib.mkIf ssh.enable {

  services.openssh = {

    # ssh address
    settings.ListenAddress = config.vars.network.wireless.address;

    # ssh port
    ports = lib.mkForce [ ssh.port ];

    # do not automatically open the ports
    openFirewall = false;

  };

}
