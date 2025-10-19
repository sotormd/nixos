{ colors, ... }:

{
  terminal.colors = {
    background = "#${colors.bg0}";
    foreground = "#${colors.fg0}";
    cursor = "#${colors.fg0}";

    color0 = "#${colors.bg3}"; # black
    color1 = "#${colors.red}"; # red
    color2 = "#${colors.green}"; # green
    color3 = "#${colors.yellow}"; # yellow
    color4 = "#${colors.blue3}"; # blue
    color5 = "#${colors.purple}"; # magenta
    color6 = "#${colors.blue1}"; # cyan
    color7 = "#${colors.fg1}"; # white

    color8 = "#${colors.bg2}"; # bright black
    color9 = "#${colors.red}"; # bright red
    color10 = "#${colors.green}"; # bright green
    color11 = "#${colors.yellow}"; # bright yellow
    color12 = "#${colors.blue2}"; # bright blue
    color13 = "#${colors.purple}"; # bright magenta
    color14 = "#${colors.blue0}"; # bright cyan
    color15 = "#${colors.fg2}"; # bright white
  };
}
