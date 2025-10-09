{ vars, ... }:

{
  home-manager.users.${vars.user.name} =
    if (vars.network.server.enable == true) then
      {
        programs.ssh.matchBlocks.server = {
          hostname = vars.network.server.ip;
          port = vars.network.server.ssh.port;
          user = vars.user.name;
          identityFile = "/home/${vars.user.name}/.ssh/${vars.network.server.ssh.keyfile}";
          identitiesOnly = true;
        };
      }
    else
      { };
}
