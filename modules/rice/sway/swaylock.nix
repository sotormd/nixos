{ colors, ... }:

{
  # enable swaylock
  programs.swaylock.enable = true;

  # settings for swaylock
  programs.swaylock.settings = {
    # background image
    image = "~/.local/share/backgrounds/lock.png";

    # fonts
    font = "IBM Plex Sans";
    font-size = 16;

    # colors
    bs-hl-color = "#${colors.yellow}00";
    inside-color = "#${colors.bg0}00";
    inside-clear-color = "#${colors.yellow}00";
    inside-ver-color = "#${colors.blue2}00";
    inside-wrong-color = "#${colors.red}00";
    key-hl-color = "#${colors.blue2}00";
    ring-color = "#${colors.bg0}00";
    ring-clear-color = "#${colors.yellow}";
    ring-ver-color = "#${colors.blue2}";
    ring-wrong-color = "#${colors.red}";
    text-color = "#${colors.bg0}00";
    text-ver-color = "#${colors.bg0}00";
    text-clear-color = "#${colors.bg0}00";
    text-wrong-color = "#${colors.bg0}00";
    text-caps-lock-color = "#${colors.yellow}00";
    inside-caps-lock-color = "#00000000";
    ring-caps-lock-color = "#00000000";
    line-color = "#00000000";
    line-clear-color = "#00000000";
    line-ver-color = "#00000000";
    line-wrong-color = "#00000000";
    line-caps-lock-color = "#00000000";
    separator-color = "#00000000";
    caps-lock-bs-hl-color = "#00000000";
    caps-lock-key-hl-color = "#00000000";
    layout-bg-color = "#00000000";
    layout-border-color = "#00000000";
    layout-text-color = "#00000000";

    # indicator options
    indicator-radius = 200;
    indicator-thickness = 7;

    # line options
    line-uses-inside = true;
    line-uses-ring = true;
  };
}
