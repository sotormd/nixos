{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  # disable pulseaudio
  services.pulseaudio.enable = false;

  # pulseaudio backend for pipewire
  services.pipewire.pulse.enable = true;
}
