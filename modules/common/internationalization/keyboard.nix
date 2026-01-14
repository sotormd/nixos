{ config, ... }:

{
  # keyboard layout
  services.xserver.xkb = {
    layout = config.vars.i18n.keyboard;
    variant = "";
  };
}
