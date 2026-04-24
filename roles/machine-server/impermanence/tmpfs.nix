{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.vars.features.impermanence.enable {

    fileSystems =

      lib.mkTmpRaw
        [ ]
        [
          "/usr"
        ]

      # nosuid,nodev,noexec
      // lib.mkTmpData [
        "/bin"
        "/etc"
        "/lib"
        "/lib64"
        "/home"
        "/root"
        "/srv"
        "/var"
      ];

  };

}
