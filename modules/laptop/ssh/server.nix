{ config, lib, ... }:

{
  config = lib.mkIf config.vars.network.server.enable {
    programs.ssh.extraConfig = ''
      Host server
          IdentitiesOnly yes
          User ${config.vars.user.name}
          HostName ${config.vars.network.server.ip}
          Port ${toString config.vars.network.server.ssh.port}
          IdentityFile /home/${config.vars.user.name}/.ssh/${config.vars.network.server.ssh.keyfile}
    '';
  };
}
