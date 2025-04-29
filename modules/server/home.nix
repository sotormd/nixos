{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    # set user dirs
    xdg.userDirs = {
      enable = true;
      desktop = null;
      documents = null;
      download = null;
      pictures = null;
    };
  };
}
