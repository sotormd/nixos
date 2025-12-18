{ config, ... }:

{
  terminal.colors = {
    background = "#${config.colors.bg0}";
    foreground = "#${config.colors.fg0}";
    cursor = "#${config.colors.fg0}";

    color0 = "#${config.colors.bg3}"; # black
    color1 = "#${config.colors.red}"; # red
    color2 = "#${config.colors.green}"; # green
    color3 = "#${config.colors.yellow}"; # yellow
    color4 = "#${config.colors.blue3}"; # blue
    color5 = "#${config.colors.purple}"; # magenta
    color6 = "#${config.colors.blue1}"; # cyan
    color7 = "#${config.colors.fg1}"; # white

    color8 = "#${config.colors.bg2}"; # bright black
    color9 = "#${config.colors.red}"; # bright red
    color10 = "#${config.colors.green}"; # bright green
    color11 = "#${config.colors.yellow}"; # bright yellow
    color12 = "#${config.colors.blue2}"; # bright blue
    color13 = "#${config.colors.purple}"; # bright magenta
    color14 = "#${config.colors.blue0}"; # bright cyan
    color15 = "#${config.colors.fg2}"; # bright white
  };
}
