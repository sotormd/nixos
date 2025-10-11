{ vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    home.file = {
      ".local/share/backgrounds/wall.png".source = ./${vars.outputs.wallpaper}.png;
      ".local/share/backgrounds/lock.png".source = ./${vars.outputs.lockscreen}.png;
    };
  };
}
