{
  # add zfs support
  boot.supportedFilesystems = [ "zfs" ];

  # respect zfs safety stuff
  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;
}
