{ vars, ... }:

{
  imports = [
    ./css.nix

    ./firejail.nix

    ./profile.nix

    ./proxy.nix

    ./settings.nix
  ];

  home-manager.users."${vars.user.name}" = {
    programs.firefox.enable = true;
    programs.firefox.package = null;
  };
}
