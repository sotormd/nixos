{
  roles = {
    blank = _: { };
    image-gnome = _: { imports = [ ./image-gnome ]; };
    image-gnome-remote = _: { imports = [ ./image-gnome-remote ]; };
    image-minimal = _: { imports = [ ./image-minimal ]; };
    image-minimal-remote = _: { imports = [ ./image-minimal-remote ]; };
    image-sd = _: { imports = [ ./image-sd ]; };
    image-sd-remote = _: { imports = [ ./image-sd-remote ]; };
    machine-pi = _: { imports = [ ./machine-pi ]; };
    machine-server = _: { imports = [ ./machine-server ]; };
    machine-workstation = _: { imports = [ ./machine-workstation ]; };
  };
}
