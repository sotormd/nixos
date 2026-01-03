{ lib, ... }:

rec {
  persistMount = source: destination: {
    fileSystems.${destination} = {
      device = source;
      options = [
        "bind"
        "x-gvfs-hide"
      ];
    };
  };

  persistDirs =
    root: dirs:
    builtins.foldl' (acc: dir: lib.recursiveUpdate acc (persistMount "${root}${dir}" dir)) { } dirs;
}
