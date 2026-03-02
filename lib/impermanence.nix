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

  bind = options: source: destination: {
    ${destination} = {
      device = source;
      options = [
        "bind"
        "x-gvfs-hide"
      ]
      ++ options;
    };
  };

  persist =
    root: dirs:
    builtins.foldl' (acc: dir: acc // bind dir.options "${root}${dir.path}" dir.path) { } dirs;

  persistDirs = dirs: persist "/persist/root" dirs;

  loopDirs = dirs: builtins.foldl' (acc: dir: acc // bind dir.options dir.path dir.path) { } dirs;
in
{
  inherit
    mountHarden
    mountData
    mountImmutable
    mountStatic
    ;

  mkPersistRaw =
    dirs:
    persistDirs (
      map (dir: {
        path = dir;
        options = [ ];
      }) dirs
    );

  mkPersistHarden =
    dirs:
    persistDirs (
      map (dir: {
        path = dir;
        options = mountHarden;
      }) dirs
    );

  mkPersistData =
    dirs:
    persistDirs (
      map (dir: {
        path = dir;
        options = mountData;
      }) dirs
    );

  mkPersistImmutable =
    dirs:
    persistDirs (
      map (dir: {
        path = dir;
        options = mountImmutable;
      }) dirs
    );

  mkPersistStatic =
    dirs:
    persistDirs (
      map (dir: {
        path = dir;
        options = mountStatic;
      }) dirs
    );

  mkLoopHarden =
    dirs:
    loopDirs (
      map (dir: {
        path = dir;
        options = mountHarden;
      }) dirs
    );

  mkLoopData =
    dirs:
    loopDirs (
      map (dir: {
        path = dir;
        options = mountData;
      }) dirs
    );

  mkLoopImmutable =
    dirs:
    loopDirs (
      map (dir: {
        path = dir;
        options = mountImmutable;
      }) dirs
    );

  mkLoopStatic =
    dirs:
    loopDirs (
      map (dir: {
        path = dir;
        options = mountStatic;
      }) dirs
    );
}
