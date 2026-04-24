{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.ssh.enable {

    # ssh address
    services.openssh.settings.ListenAddress = config.vars.wireless.address;

    # ssh port
    services.openssh.ports = lib.mkForce [ config.vars.services.ssh.port ];

    # do not automatically open the ports
    services.openssh.openFirewall = false;

  };
}
