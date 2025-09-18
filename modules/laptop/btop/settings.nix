{ vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    programs.btop.settings = {
      color_theme = "nord";
    };
  };
}
