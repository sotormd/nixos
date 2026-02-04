# experimental selinux support
# pulled from https://github.com/notashelf/nyx

{ pkgs, ... }:

{
  systemd.package = pkgs.systemd.override { withSelinux = true; };

  boot = {
    kernelParams = [
      "security=selinux"
      "selinux=1"
    ];
    kernelPatches = [
      {
        name = "selinux-config";
        patch = null;
        extraConfig = ''
          SECURITY_SELINUX y
          SECURITY_SELINUX_BOOTPARAM n
          SECURITY_SELINUX_DISABLE n
          SECURITY_SELINUX_DEVELOP y
          SECURITY_SELINUX_AVC_STATS y
          SECURITY_SELINUX_CHECKREQPROT_VALUE 0
          DEFAULT_SECURITY_SELINUX n
        '';
      }
    ];
  };

  environment = {
    systemPackages = [ pkgs.policycoreutils ];

    etc."selinux/config".text = ''
      # This file controls the state of SELinux on the system.
      # SELINUX= can take one of these three values:
      #     enforcing - SELinux security policy is enforced.
      #     permissive - SELinux prints warnings instead of enforcing.
      #     disabled - No SELinux policy is loaded.
      SELINUX=permissive

      # SELINUXTYPE= can take one of three two values:
      #     targeted - Targeted processes are protected,
      #     minimum - Modification of targeted policy. Only selected processes are protected.
      #     mls - Multi Level Security protection.
      SELINUXTYPE=mls
    '';
  };
}
