{ pkgs, ... }:

{
  # packages to appear in the system environment
  home.packages = with pkgs; [
    micro
    procps
    killall
    diffutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    fastfetch
    stack
    cabal-install
    ghc
    cargo
    rustc
    go
    openssh
    git
    python3
    less
    curl
    wget
    findutils
    coreutils
    less
    bashInteractive
    htop
    ncurses
    nano
    imagemagick
    tree
  ];
}
