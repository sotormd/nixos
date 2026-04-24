{
  profiles = {
    desktop = _: { imports = [ ./desktop.nix ]; };
    image = _: { imports = [ ./image.nix ]; };
    laptop = _: { imports = [ ./laptop.nix ]; };
    machine = _: { imports = [ ./machine.nix ]; };
    pi = _: { imports = [ ./pi.nix ]; };
    selfhost = _: { imports = [ ./selfhost.nix ]; };
  };
}
