{
  # nixos wants to enable grub by default
  boot.loader.grub.enable = false;

  # use the extlinux boot loader
  boot.loader.generic-extlinux-compatible.enable = true;
}
