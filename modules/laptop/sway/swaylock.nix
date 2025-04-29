{
  home-manager,
  vars,
  colors,
  ...
}:

{
  # to unlock sessions with swaylock
  security.pam.services.swaylock = { };

  home-manager.users."${vars.user.name}" = {
    # enable swaylock
    programs.swaylock.enable = true;

    # settings for swaylock
    programs.swaylock.settings = {
      # background image
      image = "~/.local/share/backgrounds/bg.png";

      # fonts
      font = "IBM Plex Sans";
      font-size = 16;

      # colors
      bs-hl-color = "#${colors.yellow}";
      inside-color = "#${colors.bg0}";
      inside-clear-color = "#${colors.yellow}";
      inside-ver-color = "#${colors.blue2}";
      inside-wrong-color = "#${colors.red}";
      key-hl-color = "#${colors.blue2}";
      ring-color = "#${colors.bg0}";
      ring-clear-color = "#${colors.yellow}";
      ring-ver-color = "#${colors.blue2}";
      ring-wrong-color = "#${colors.red}";
      text-color = "#${colors.bg0}";
      text-caps-lock-color = "#${colors.yellow}";

      # indicator options
      indicator-radius = 70;
      indicator-thickness = 9;

      # line options
      line-uses-inside = true;
      line-uses-ring = true;
    };
  };
}
