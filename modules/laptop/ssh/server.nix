{ vars, ... }:

{
  programs.ssh.extraConfig = ''
    Host server
        IdentitiesOnly yes
        User ${vars.user.name}
        HostName ${vars.network.server.ip}
        Port ${toString vars.network.server.ssh.port}
        IdentityFile /home/${vars.user.name}/.ssh/${vars.network.server.ssh.keyfile}
  '';
}
