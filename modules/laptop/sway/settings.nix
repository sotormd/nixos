{
  # opengl support
  hardware.graphics.enable = true;

  # to run gui applications as root
  security.polkit.enable = true;

  # run chromium / electron apps under wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

}
