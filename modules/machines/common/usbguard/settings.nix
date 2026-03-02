{ pkgs, ... }:

{
  services.usbguard = {
    # only allow root
    IPCAllowedUsers = [ "root" ];

    # allow devices that are already connected when the daemon starts
    presentDevicePolicy = "allow";

    # block suspicious devices
    # https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/security_guide/sec-using-usbguard
    rules = ''
      reject with-interface all-of { 08:*:* 03:00:* }
      reject with-interface all-of { 08:*:* 03:01:* }
      reject with-interface all-of { 08:*:* e0:*:* }
      reject with-interface all-of { 08:*:* 02:*:* }
    '';
  };

  environment.systemPackages = [ pkgs.usbguard ];
}
