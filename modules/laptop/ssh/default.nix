{ home-manager, vars, ... }:

{
  imports = [
    ./github.nix

    ./server.nix
  ];

  home-manager.users."${vars.user.name}" = {
    programs.ssh.enable = true;
  };
}
