{
  legacyVars,
  config,
  lib,
  pkgs,
  ...
}:

let
  desktops = [
    "gnome"
  ];

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
        ../../common/network/nts.nix

        # nix
        # self-explanatory
        ../../common/nix

        # packages
        # probably need these basic ones
        ../../common/packages

        # sandbox
        # eh just firejail
        ../../common/sandbox

        # sudo
        # gotta have sudo
        ../../common/sudo

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

        # impermanence - rollbacks + bind root
        # we will not persist anything in /home
        ../impermanence/rollback-root.nix
        ../impermanence/rollback-home.nix
        ../impermanence/bind-root.nix

        # sops-nix secrets
        # we need it for user password
        ../../common/sops
        ../sops

        # virtualization
        # might need this
        ../virtualization

        # nomad desktop configuration
        ./${desktop}.nix
      ];

      config = {

        # we need to initialize variables ourselves
        # since ../../common/default.nix ix not imported
        vars = legacyVars // {
          flake.nixosRole = "nomad";
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

        # firejailed librewolf browser
        programs.firejail.wrappedBinaries.librewolf = {
          executable = "${pkgs.librewolf}/bin/librewolf";
          profile = "${pkgs.firejail}/etc/firejail/librewolf.profile";
          extraArgs = [
            "--nonewprivs"

            "--private"

            "--caps.drop=all"

            "--noroot"

            "--private-cache"
            "--private-cwd"
            "--private-dev"
            "--private-etc"
            "--private-tmp"

            "--seccomp"
          ];
        };

        # filesystem hardening
        fileSystems =

          # nosuid, nodev, noexec, ro
          lib.mkLoopStatic [

            # nixos flake
            config.vars.flake.nixosDirectory

            # sops-nix
            "/persist/sops-nix"

            # original home directory
            "/persist/root/home"

          ];

        # use the same state version
        system.stateVersion = "24.05";

      };
    };
  };
in
{
  config = lib.mkIf config.vars.features.impermanence.enable {
    specialisation = lib.genAttrs desktops mkSpec;
  };
}
