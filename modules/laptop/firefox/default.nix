{ home-manager, vars, ... }:

{
  imports = [
    ./addons.nix

    ./config.nix

    ./css.nix

    ./home.nix

    ./policies.nix

    ./profiles.nix

    ./search.nix
  ];

  home-manager.users."${vars.user.name}" = {
    programs.firefox.enable = true;
  };
}
