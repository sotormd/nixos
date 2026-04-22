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
    ${pkgs.coreutils-full}/bin/chown "$USER": -R "/persist/nixos"

    # directories: 700 (except .git)
    ${pkgs.findutils}/bin/find "/persist/nixos" \
      -path "/persist/nixos/.git" -prune -o \
      -type d -exec ${pkgs.coreutils-full}/bin/chmod 700 {} +

    # files: 600 (except .git)
    ${pkgs.findutils}/bin/find "/persist/nixos" \
      -path "/persist/nixos/.git" -prune -o \
      -type f -exec ${pkgs.coreutils-full}/bin/chmod 600 {} +

    # scripts explicitly executable
    ${pkgs.coreutils-full}/bin/chmod -R 700 "/persist/nixos/cli"
  '';
in
{
  systemd.services.persist-dir-setup = {
    description = "Set persist directory permissions";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig.Type = "oneshot";
    inherit script;
  };
}
