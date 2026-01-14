{ config, lib, ... }:

let
  user = config.vars.user.name;
in
lib.mkIf config.vars.device.impermanence.enable (
  lib.persistDirs "/persist/root" [
    # Documents, Downloads, Pictures, Projects
    "/home/${user}/Documents"
    "/home/${user}/Downloads"
    "/home/${user}/Pictures"
    "/home/${user}/Projects"

    # OpenSSH keys
    "/home/${user}/.ssh"

    # Brave Browser
    "/home/${user}/.config/BraveSoftware/Brave-Browser"
  ]
)
