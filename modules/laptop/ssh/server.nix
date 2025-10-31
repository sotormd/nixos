{ lib, vars, ... }:

{
  home-manager.users.${vars.user.name} = lib.mkMerge (
    lib.optional vars.network.server.enable {
      programs.ssh.matchBlocks.server = {
        hostname = vars.network.server.ip;
        port = vars.network.server.ssh.port;
        user = vars.user.name;
        identityFile = "/home/${vars.user.name}/.ssh/${vars.network.server.ssh.keyfile}";
        identitiesOnly = true;
      };
    }
  );
}
