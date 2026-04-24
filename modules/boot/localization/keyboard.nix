{ config, ... }:

{
  # keyboard layout
  services.xserver.xkb = {
    layout = config.vars.localization.keyboard;
    variant = "";
  };
}
