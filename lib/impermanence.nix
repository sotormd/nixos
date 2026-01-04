rec {
  persistMount = source: destination: {
    ${destination} = {
      device = source;
      options = [
        "bind"
        "x-gvfs-hide"
      ];
    };
  };

  persistDirs = root: dirs: {
    fileSystems = builtins.foldl' (acc: dir: acc // persistMount "${root}${dir}" dir) { } dirs;
  };
}
