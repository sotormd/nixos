{ home-manager, vars, ... }:

{
  imports = [
    # include results of the hardware scan
    ./hardware-configuration.nix

    # MODULES - sorted alphabetically

    # bootloader, kernel parameters, sysctl options
    ./boot

    # invisible internet protocol daemon
    ./i2pd

    # jellyfin media server
    ./jellyfin

    # networking
    ./network

    # nginx web server
    ./nginx

    # packages
    ./packages

    # qbittorrent
    ./qbt

    # metasearch engine
    ./searxng

    # sops-nix secrets management
    ./sops

    # secure shell
    ./ssh

    # vaultwarden password manager
    ./vaultwarden

    # unbound validating recursive dns server
    ./unbound
  ];

  home-manager.users."${vars.user.name}" = {
    # set user dirs
    xdg.userDirs = {
      enable = true;
      documents = null;
      download = null;
      pictures = null;
    };
  };
}
