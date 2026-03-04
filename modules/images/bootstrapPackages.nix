{ pkgs, ... }:

[
  pkgs.bash
  pkgs.coreutils-full
  pkgs.gawk
  pkgs.gnugrep
  pkgs.tree
  pkgs.rsync
  pkgs.openssh
  pkgs.man

  pkgs.nixos-rebuild-ng
  pkgs.nixos-install-tools
  pkgs.lix
  pkgs.nixfmt

  pkgs.cryptsetup
  pkgs.zfs
  pkgs.dosfstools
  pkgs.util-linux
  pkgs.udev

  pkgs.git
  pkgs.gnupg
  pkgs.sops
  pkgs.yq
  pkgs.mkpasswd
  pkgs.sbctl
]
