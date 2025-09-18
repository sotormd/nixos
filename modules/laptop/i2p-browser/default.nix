{ vars, ... }:

{
  imports =
    if (vars.network.server.enabled == true) then
      [
        ./css.nix

        ./firejail.nix

        ./profile.nix

        ./proxy.nix

        ./settings.nix
      ]
    else
      [ ];

  home-manager.users."${vars.user.name}" =
    if (vars.network.server.enabled == true) then
      {
        programs.firefox.enable = true;
        programs.firefox.package = null;
      }
    else
      { };
}
