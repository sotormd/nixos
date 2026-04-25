{
  profiles = {
    desktop = _: { imports = [ ./desktop.nix ]; };
    image = _: { imports = [ ./image.nix ]; };
    machine = _: { imports = [ ./machine.nix ]; };
    raspi = _: { imports = [ ./raspi.nix ]; };
    selfhost = _: { imports = [ ./selfhost.nix ]; };
    workstation = _: { imports = [ ./workstation.nix ]; };
  };
}
