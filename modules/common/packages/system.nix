{ lib, pkgs, ... }:

{
  # do not install any packages by default
  environment.defaultPackages = lib.mkForce [ ];

  # set of packages to appear in system environment
  environment.systemPackages = with pkgs; [

    # tools for manipulating access control lists
    acl

    # tools for manipulating extended attributes
    attr

    # the GNU bourne again shell
    # bash with ncurses support
    bashInteractive

    # tools for manipulating binaries
    binutils

    # the GNU core utilities
    coreutils-full

    # create or extract from cpio archives
    cpio

    # transfer files with url syntax
    curl

    # retrieve files using HTTP/HTTPS/FTP
    wget

    # show differences between files
    diffutils

    # GNU findutils
    findutils

    # GNU implemenation of awk
    gawk

    # get entries from system databases
    getent

    # get system configuration values
    getconf

    # GNU implementation of grep
    gnugrep

    # apply differences to files
    gnupatch

    # batch stream editor
    gnused

    # GNU implemenation of tar archiver
    gnutar

    # GNU zip compression
    gzip

    # control the TCP/IP stack
    iproute2

    # general purpose compression
    xz

    # file pager
    less

    # library for working with POSIX capabilities
    libcap

    # curses
    ncurses

    # read and write data across data connections
    netcat

    # frontend to crypt
    mkpasswd

    # information from /proc
    procps

    # fast, incremental file transfer utility
    rsync

    # monitor the health of hard drives
    smartmontools

    # system call tracer
    strace

    # authentication related tools
    su

    # run programs and summarize system resources used
    time

    # set of system utilities for linux
    util-linux

    # show full path of shell commands
    which

    # zstandard compression
    zstd

    # working with .zip archives
    zip
    unzip

    # list open files
    lsof

    # show type of files
    file

  ];
}
