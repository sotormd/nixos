{ vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    programs.zathura.options.font = "IBM Plex Mono";
  };
}
