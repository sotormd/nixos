{ vars, ... }:

{
  # keyboard layout
  services.xserver.xkb = {
    layout = vars.i18n.keyboard;
    variant = "";
  };
}
