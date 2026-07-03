{
  # add support for various filesystems
  boot.supportedFilesystems = [
    "zfs"
    "ext4"
    "xfs"
    "vfat"
    "ntfs"
  ];

  # automatic zpool scrubbing
  services.zfs.autoScrub.enable = true;

  # respect zfs safety stuff
  boot.zfs.forceImportRoot = true;
  boot.zfs.forceImportAll = false;
}
