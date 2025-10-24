{
  # start waybar in sway
  wayland.windowManager.sway.config = {
    bars = [
      {
        command = "waybar";
        position = "top";
      }
    ];
  };
}
