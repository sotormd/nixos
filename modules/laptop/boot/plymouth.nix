{
  # enable plymouth graphical boot animation
  boot.plymouth.enable = true;

  # fix plymouth delay
  boot.kernelParams = [ "plymouth.use-simpledrm" ];
}
