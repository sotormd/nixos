{
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
