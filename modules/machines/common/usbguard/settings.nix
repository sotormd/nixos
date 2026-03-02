{ pkgs, ... }:

{
  services.usbguard = {
    # only allow root
    IPCAllowedUsers = [ "root" ];

    # allow devices that are already connected when the daemon starts
    presentDevicePolicy = "allow";
  };

  environment.systemPackages = [ pkgs.usbguard ];
}
