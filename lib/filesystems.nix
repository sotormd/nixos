let
  mountHarden = [
    "nosuid"
    "nodev"
  ];

  mountData = mountHarden ++ [
    "noexec"
  ];

  mountImmutable = mountHarden ++ [
    "ro"
  ];

  mountStatic = mountHarden ++ [
    "noexec"
    "ro"
  ];

  bind = options: source: destination: extra: {
    ${destination} = {
      device = source;
      fsType = "none";
      options = [
        "bind"
        "x-gvfs-hide"
      ]
      ++ options;
    }
    // extra;
  };

  tmp = options: dir: {
    ${dir} = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" ] ++ options;
      neededForBoot = true;
    };
  };

  persistDirs =
    root: dirs:
    builtins.foldl' (acc: dir: acc // bind dir.options "${root}${dir.path}" dir.path { }) { } dirs;

  persistDirsEarly =
    root: dirs:
    builtins.foldl' (
      acc: dir: acc // bind dir.options "${root}${dir.path}" dir.path { neededForBoot = true; }
    ) { } dirs;

  selfDirs =
    dirs:
    builtins.foldl' (
      acc: dir: acc // bind dir.options dir.path dir.path { neededForBoot = true; }
    ) { } dirs;

  tmpDirs = dirs: builtins.foldl' (acc: dir: acc // tmp dir.options dir.path) { } dirs;

  mkPersistRaw =
    options: root: dirs:
    persistDirs root (
      map (dir: {
        path = dir;
        inherit options;
      }) dirs
    );

  mkPersistHarden = root: dirs: mkPersistRaw mountHarden root dirs;

  mkPersistData = root: dirs: mkPersistRaw mountData root dirs;

  mkPersistImmutable = root: dirs: mkPersistRaw mountImmutable root dirs;

  mkPersistStatic = root: dirs: mkPersistRaw mountStatic root dirs;

  mkPersistRawEarly =
    options: root: dirs:
    persistDirsEarly root (
      map (dir: {
        path = dir;
        inherit options;
      }) dirs
    );

  mkPersistHardenEarly = root: dirs: mkPersistRawEarly mountHarden root dirs;

  mkPersistDataEarly = root: dirs: mkPersistRawEarly mountData root dirs;

  mkPersistImmutableEarly = root: dirs: mkPersistRawEarly mountImmutable root dirs;

  mkPersistStaticEarly = root: dirs: mkPersistRawEarly mountStatic root dirs;

  mkSelfRaw =
    options: dirs:
    selfDirs (
      map (dir: {
        path = dir;
        inherit options;
      }) dirs
    );

  mkSelfHarden = dirs: mkSelfRaw mountHarden dirs;

  mkSelfData = dirs: mkSelfRaw mountData dirs;

  mkSelfImmutable = dirs: mkSelfRaw mountImmutable dirs;

  mkSelfStatic = dirs: mkSelfRaw mountStatic dirs;

  mkTmpRaw =
    options: dirs:
    tmpDirs (
      map (dir: {
        path = dir;
        inherit options;
      }) dirs
    );

  mkTmpHarden = dirs: mkTmpRaw mountHarden dirs;

  mkTmpData = dirs: mkTmpRaw mountData dirs;

  mkTmpImmutable = dirs: mkTmpRaw mountImmutable dirs;

  mkTmpStatic = dirs: mkTmpRaw mountStatic dirs;

  recursiveImport =
    let
      hasSuffix =
        suffix: str:
        let
          n = builtins.stringLength suffix;
          m = builtins.stringLength str;
        in
        m >= n && builtins.substring (m - n) n str == suffix;

      listFilesRecursive =
        dir:
        builtins.concatMap (
          entry:
          let
            path = dir + "/${entry}";
          in
          if builtins.readFileType path == "directory" then listFilesRecursive path else [ path ]
        ) (builtins.attrNames (builtins.readDir dir));

      expandIfFolder =
        elem:
        if !builtins.isPath elem || builtins.readFileType elem != "directory" then
          [ elem ]
        else
          listFilesRecursive elem;

    in
    list:
    builtins.filter (elem: !builtins.isPath elem || hasSuffix ".nix" (toString elem)) (
      builtins.concatMap expandIfFolder list
    );

in
{
  inherit
    mountHarden
    mountData
    mountImmutable
    mountStatic
    ;

  inherit
    mkPersistRaw
    mkPersistHarden
    mkPersistData
    mkPersistImmutable
    mkPersistStatic
    ;

  inherit
    mkPersistRawEarly
    mkPersistHardenEarly
    mkPersistDataEarly
    mkPersistImmutableEarly
    mkPersistStaticEarly
    ;

  inherit
    mkSelfRaw
    mkSelfHarden
    mkSelfData
    mkSelfImmutable
    mkSelfStatic
    ;

  inherit
    mkTmpRaw
    mkTmpHarden
    mkTmpData
    mkTmpImmutable
    mkTmpStatic
    ;

  inherit recursiveImport;
}
