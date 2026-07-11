{
  # run chromium / electron apps under wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # opengl support
  hardware.graphics.enable = true;

  # dconf
  programs.dconf.enable = true;

  # disable portals
  xdg.portal = {
    enable = false;
    wlr.enable = false;
    config.common.default = "*";
  };
}
