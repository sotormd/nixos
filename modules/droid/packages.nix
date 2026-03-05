{ pkgs, ... }:

{
  # packages to appear in the system environment
  environment.packages = [

    # text editor with mouse/touch support
    pkgs.micro

    # haskell
    pkgs.stack
    pkgs.cabal-install
    pkgs.ghc

    # rust
    pkgs.cargo
    pkgs.rustc

    # go
    pkgs.go

    # python
    pkgs.python3

    # image manipulation
    pkgs.imagemagick

    # metadata anonymization
    pkgs.mat2

    # text editors
    pkgs.nano
    pkgs.vim

    # version control
    pkgs.git

    # resource monitor
    pkgs.htop

    # list contents of directories in a tree-like format
    pkgs.tree

    # tools for manipulating access control lists
    pkgs.acl

    # tools for manipulating extended attributes
    pkgs.attr

    # the GNU bourne again shell
    # bash with ncurses support
    pkgs.bashInteractive

    # tools for manipulating binaries
    pkgs.binutils

    # the GNU core utilities
    pkgs.coreutils

    # create or extract from cpio archives
    pkgs.cpio

    # transfer files with url syntax
    pkgs.curl

    # retrieve files using HTTP/HTTPS/FTP
    pkgs.wget

    # show differences between files
    pkgs.diffutils

    # GNU findutils
    pkgs.findutils

    # GNU implemenation of awk
    pkgs.gawk

    # get entries from system databases
    pkgs.getent

    # get system configuration values
    pkgs.getconf

    # GNU implementation of grep
    pkgs.gnugrep

    # apply differences to files
    pkgs.gnupatch

    # batch stream editor
    pkgs.gnused

    # GNU implemenation of tar archiver
    pkgs.gnutar

    # control the TCP/IP stack
    pkgs.iproute2

    # dig
    pkgs.dig

    # file pager
    pkgs.less

    # library for working with POSIX capabilities
    pkgs.libcap

    # curses
    pkgs.ncurses

    # read and write data across data connections
    pkgs.netcat

    # frontend to crypt
    pkgs.mkpasswd

    # information from /proc
    pkgs.procps

    # fast, incremental file transfer utility
    pkgs.rsync

    # monitor the health of hard drives
    pkgs.smartmontools

    # system call tracer
    pkgs.strace

    # authentication related tools
    pkgs.su

    # run programs and summarize system resources used
    pkgs.time

    # set of system utilities for linux
    pkgs.util-linux

    # show full path of shell commands
    pkgs.which

    # GNU zip compression
    pkgs.gzip

    # general purpose compression
    pkgs.xz

    # zstandard compression
    pkgs.zstd

    # working with .zip archives
    pkgs.zip
    pkgs.unzip

    # ssh client protocol
    pkgs.openssh

    # list open files
    pkgs.lsof

    # show type of files
    pkgs.file

    # lspci
    pkgs.pciutils

    # lsusb
    pkgs.usbutils

    # json and yaml
    pkgs.jq
    pkgs.yq

    # luks
    pkgs.cryptsetup

    # hostname
    pkgs.hostname

    # manpages
    pkgs.man

  ];
}
