{
  config,
  pkgs,
  lib,
  ...
}:

let
  allowText = lib.concatStringsSep "\n" (map (x: "allow ${x}") config.vars.usbs);
in
{
  services.usbguard = {
    # only allow root
    IPCAllowedUsers = [ "root" ];

    # allow only declared devices
    presentDevicePolicy = "apply-policy";

    # block suspicious devices
    # https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/security_guide/sec-using-usbguard
    rules = ''
      reject with-interface all-of { 08:*:* 03:00:* }
      reject with-interface all-of { 08:*:* 03:01:* }
      reject with-interface all-of { 08:*:* e0:*:* }
      reject with-interface all-of { 08:*:* 02:*:* }
      ${allowText}
    '';
  };

  environment.systemPackages = [ pkgs.usbguard ];
}
