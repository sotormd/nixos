{
  legacyVars,
  config,
  lib,
  pkgs,
  ...
}:

let
  desktops =
    (lib.optional config.vars.features.nomad.gnome.enable "gnome")
    ++ (lib.optional config.vars.features.nomad.mate.enable "mate")
    ++ (lib.optional config.vars.features.nomad.xfce.enable "xfce")
    ++ (lib.optional config.vars.features.nomad.plasma.enable "plasma");

  mkSpec = desktop: {
    inheritParentConfig = false;

    configuration = {

      # everything needed for a clean, base system

      # modules
      imports = [

        # variable schema
        # we still need to use the variables system
        ../../../../vars-schema/common.nix
        ../../../../vars-schema/laptop.nix

        # audit
        # linux audit subsystem
        ../../common/audit

        # boot
        # kernel and boot settings, including hardening
        ../../common/boot

        # internationalization
        # time, keyboard, locale
        ../../common/internationalization

        # network - select things only
        # cherry picking only what we need
        ../../common/network/adblock.nix
        ../../common/network/disable-ipv6.nix
        ../../common/network/firewall.nix
        ../../common/network/host.nix
        ../../common/network/issue.nix
        ../../common/network/macchanger.nix
        ../../common/network/timesyncd.nix

        # nix
        # self-explanatory
        ../../common/nix

        # packages
        # probably need these basic ones
        ../../common/packages

        # sandboxing with bubblewrap
        ../../common/sandbox

        # sops-nix secrets
        # we need it for user password
        ../../common/sops

        # privilege elevation
        # polkit, run0, sudo
        ../../common/privilege

        # usbguard
        # still gotta prevent badusbs
        ../../common/usbguard

        # users
        # self-explanatory
        ../../common/users

        # audio
        # gotta hear things
        ../audio

        # bootloader
        # systems gotta boot
        ../boot

        # impermanence
        # no home directory though
        ../impermanence/rollback-root.nix
        ../impermanence/rollback-home.nix
        ../impermanence/bind-root.nix

        # virtualization
        # might need this
        ../virtualization

        # nomad desktop configuration
        ./${desktop}.nix
      ];

      config = {

        # we need to initialize variables ourselves
        # since ../../common/default.nix ix not imported
        vars = lib.recursiveUpdate legacyVars {
          role = "nomad";
          features.selfhosted.enable = false;
        };

        networking = {

          # use networkmanager
          networkmanager.enable = true;

          # use cloudflare dns
          nameservers = [
            "1.1.1.1"
            "1.0.0.1"
          ];

        };

        # allow unprivileged user namespaces
        boot.kernel.sysctl."kernel.unprivileged_userns_clone" = lib.mkForce "1";

        # librewolf - doesnt work with graphene-hardened malloc
        environment.systemPackages = [ pkgs.librewolf ];
        environment.memoryAllocator.provider = lib.mkForce "libc";

        system = {
          switch.enable = false;
          tools = {
            nixos-version.enable = false;
            nixos-rebuild.enable = false;
            nixos-option.enable = false;
            nixos-install.enable = false;
            nixos-generate-config.enable = false;
            nixos-enter.enable = false;
            nixos-build-vms.enable = false;
          };
          stateVersion = "24.05";
        };

      };
    };
  };
in
{
  config = lib.mkIf config.vars.features.impermanence.enable {
    specialisation = lib.genAttrs desktops mkSpec;
  };
}
