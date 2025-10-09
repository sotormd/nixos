{ vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    home.file = {
      ".local/share/backgrounds/bg.png".source = ./${vars.outputs.wallpaper}.png;
    };
  };
}
