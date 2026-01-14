{ config, ... }:

{
  programs.ssh.extraConfig = ''
    Host github
        IdentitiesOnly yes
        User git
        HostName github.com
        IdentityFile /home/${config.vars.user.name}/.ssh/${config.vars.user.github.keyfile}
  '';
}
