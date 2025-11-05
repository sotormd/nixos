{ vars, ... }:

{
  programs.ssh.extraConfig = ''
    Host github
        IdentitiesOnly yes
        User git
        HostName github.com
        IdentityFile /home/${vars.user.name}/.ssh/${vars.user.github.keyfile}
  '';
}
