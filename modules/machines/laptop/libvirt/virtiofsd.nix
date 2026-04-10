{ pkgs, ... }:

{
  # libvirtd qemu virtiofs support
  virtualisation.libvirtd = {
    qemu = {
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
}
