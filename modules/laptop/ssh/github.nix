{ vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    programs.ssh.matchBlocks.github = {
      hostname = "github.com";
      user = "git";
      identityFile = "/home/${vars.user.name}/.ssh/${vars.user.github.keyfile}";
      identitiesOnly = true;
    };
  };
}
