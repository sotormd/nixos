{ vars, ... }:

{
  # ssh address
  services.openssh.settings = {
    ListenAddress = vars.network.ip;
  };

  # ssh port
  services.openssh.ports = [ vars.network.ssh.port ];

  # do not automatically open the ports
  services.openssh.openFirewall = false;
}
