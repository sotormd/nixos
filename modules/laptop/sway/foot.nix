{ vars, colors, ... }:

{
  home-manager.users.${vars.user.name} = {
    # enable the foot terminal emulator
    programs.foot.enable = true;

    programs.foot.settings = {
      main = {
        font = "IBM Plex Mono:size=10";
        dpi-aware = "yes";
      };

      cursor = {
        style = "block";
      };

      colors = {
        background = colors.bg0;
        foreground = colors.fg0;

        regular0 = colors.bg1;
        regular1 = colors.red;
        regular2 = colors.green;
        regular3 = colors.yellow;
        regular4 = colors.blue2;
        regular5 = colors.purple;
        regular6 = colors.blue1;
        regular7 = colors.fg1;

        bright0 = colors.bg3;
        bright1 = colors.red;
        bright2 = colors.green;
        bright3 = colors.yellow;
        bright4 = colors.blue2;
        bright5 = colors.purple;
        bright6 = colors.blue0;
        bright7 = colors.fg2;

        cursor = "${colors.bg0} ${colors.fg0}";
      };
    };
  };
}
