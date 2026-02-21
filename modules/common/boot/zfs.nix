{
  # add support for zfs
  boot.supportedFilesystems = [ "zfs" ];

  # we import things ourselves
  boot.zfs.forceImportRoot = false;

  # automatic zpool scrubbing
  services.zfs.autoScrub.enable = true;
}
