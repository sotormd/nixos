{ config, lib, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";
in
lib.mkIf config.vars.features.impermanence.enable {

  fileSystems =

    lib.mkPersistRaw [ ] "/persist/root" [

      # distrobox containers
      "${home}/.local/share/containers"

    ]

    # nosuid, nodev
    // lib.mkPersistHarden "/persist/root" [

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

  systemd.tmpfiles.rules = [
    "d ${home}/.config 0700 ${user} ${user} -"
    "d ${home}/.config/BraveSoftware 0700 ${user} ${user} -"
    "d ${home}/.local 0700 ${user} ${user} -"
    "d ${home}/.local/share 0700 ${user} ${user} -"
  ];

}
