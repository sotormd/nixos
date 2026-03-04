{ config, lib, ... }:

let
  home = "/home/${config.vars.user.name}";
in
lib.mkIf config.vars.features.impermanence.enable {

  fileSystems =

    # nosuid, nodev
    lib.mkPersistHarden "/persist/root" [

      # Projects
      "${home}/Projects"

      # brave browser
      "${home}/.config/BraveSoftware/Brave-Browser"

    ]

    # nosuid, nodev, noexec
    // lib.mkPersistData "/persist/root" [

      # Documents, Downloads, Pictures
      "${home}/Documents"
      "${home}/Downloads"
      "${home}/Pictures"

      # ssh keys
      "${home}/.ssh"

    ];

}
