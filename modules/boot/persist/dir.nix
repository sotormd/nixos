{ config, pkgs, ... }:

let
  script = ''
    set -euo pipefail

    mkdir -p /persist/nixos
    mkdir -p /persist/sops-nix
    mkdir -p /persist/root
    mkdir -p /persist/keys

    chown root: /persist/sops-nix
    chown root: /persist/root
    chown root: /persist/keys

    chmod 700 /persist/sops-nix
    chmod 700 /persist/root
    chmod 700 /persist/keys

    USER="${config.vars.user.name}"

    # chown directory
    chown "$USER": -R "/persist/nixos"

    # directories: 700 (except .git)
    find "/persist/nixos" \
      -path "/persist/nixos/.git" -prune -o \
      -type d -exec chmod 700 {} +

    # files: 600 (except .git)
    find "/persist/nixos" \
      -path "/persist/nixos/.git" -prune -o \
      -type f -exec chmod 600 {} +

    # scripts explicitly executable
    chmod -R 700 "/persist/nixos/cli"
  '';
in
{
  systemd.services.persist-dir-setup = {
    description = "Set persist directory permissions";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    path = [
      pkgs.coreutils
      pkgs.findutils
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    inherit script;
  };
}
