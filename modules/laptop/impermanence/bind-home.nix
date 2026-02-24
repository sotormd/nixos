{ config, lib, ... }:

let
  user = config.vars.user.name;
in
lib.mkIf config.vars.features.impermanence.enable (
  lib.persistDirs "/persist/root" [
    # Documents, Downloads, Pictures, Projects
    "/home/${user}/Documents"
    "/home/${user}/Downloads"
    "/home/${user}/Pictures"
    "/home/${user}/Projects"

    # ssh keys
    "/home/${user}/.ssh"

    # brave browser
    "/home/${user}/.config/BraveSoftware/Brave-Browser"
  ]
)
