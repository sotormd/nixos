{ config, ... }:

{
  services.openssh.settings = {
    # only allow the main user
    AllowUsers = [ config.vars.user.name ];
    AllowGroups = [ config.vars.user.name ];

    # disable root login
    PermitRootLogin = "no";

    # disable password authentication
    PasswordAuthentication = false;

    # only allow three authentication tries
    MaxAuthTries = 3;

    # only allow two concurrent sessions
    MaxSessions = 2;
    ClientAliveCountMax = 2;

    # general hardening
    AllowTCPForwarding = false;
    TCPKeepAlive = false;
    AllowAgentForwarding = false;

    # verbose logging
    LogLevel = "VERBOSE";
  };

  # authorized keys
  users.users."${config.vars.user.name}".openssh.authorizedKeys.keys = config.vars.network.ssh.keys;
}
