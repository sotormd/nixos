{
  # add support for zfs
  boot.supportedFilesystems = [ "zfs" ];

  # automatic zpool scrubbing
  services.zfs.autoScrub.enable = true;
}
