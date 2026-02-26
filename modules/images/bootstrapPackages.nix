{ pkgs, ... }:

[
  pkgs.lix
  pkgs.nixos-rebuild-ng
  pkgs.nixos-install-tools

  pkgs.cryptsetup
  pkgs.zfs
  pkgs.dosfstools
  pkgs.util-linux
  pkgs.udev

  pkgs.bash
  pkgs.coreutils-full
  pkgs.gawk
  pkgs.gnugrep
  pkgs.sops
  pkgs.gnupg
  pkgs.yq
  pkgs.mkpasswd
  pkgs.git

  pkgs.tree
  pkgs.rsync
  pkgs.openssh
  pkgs.sbctl
  pkgs.nixfmt

  pkgs.systemd
]
