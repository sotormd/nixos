{ colors, ... }:

{
  services.dunst.settings = {
    global = {
      background = "#${colors.bg0}";
      corner_radius = 7;
      font = "IBM Plex Sans 9";
      frame_color = "#${colors.blue2}";
      gap_size = 5;
      offset = "5x5";
      origin = "top-right";
      monitor = 1;
    };
    urgency_critical = {
      frame_color = "#${colors.yellow}";
    };
  };
}
