{ vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    programs.foot.settings = {
      main = {
        font = "IBM Plex Mono:size=10";
        dpi-aware = "yes";
      };
      cursor = {
        style = "block";
      };
    };
  };
}
