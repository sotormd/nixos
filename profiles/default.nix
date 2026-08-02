{
  profiles = {
    deskspec = _: { imports = [ ./deskspec.nix ]; };
    desktop = _: { imports = [ ./desktop.nix ]; };
    image = _: { imports = [ ./image.nix ]; };
    laptop = _: { imports = [ ./laptop.nix ]; };
    machine = _: { imports = [ ./machine.nix ]; };
    raspi = _: { imports = [ ./raspi.nix ]; };
    selfhost = _: { imports = [ ./selfhost.nix ]; };
    svcvm = _: { imports = [ ./svcvm.nix ]; };
  };
}
