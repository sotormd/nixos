{ config, ... }:

{
  # ssh address
  services.openssh.settings = {
    ListenAddress = config.vars.network.ip;
  };

  # ssh port
  services.openssh.ports = [ config.vars.network.ssh.port ];

  # do not automatically open the ports
  services.openssh.openFirewall = false;
}
