{ config, pkgs, ... }:

let
  script = pkgs.writeShellScript "nixos-dir-perms" ''
    #!/usr/bin/env bash

        NIXOS_DIR=${config.vars.flake.nixosDirectory}
        USER=${config.vars.user.name}

        # chown directory
        ${pkgs.coreutils-full}/bin/chown $USER: -R $NIXOS_DIR

        # chown everything except .git
        ${pkgs.findutils}/bin/find "$NIXOS_DIR" \
          -path "$NIXOS_DIR/.git" -prune -o \
          -exec ${pkgs.coreutils-full}/bin/chown "$USER:$USER" {} +

        # directories: 700 (except .git)
        ${pkgs.findutils}/bin/find "$NIXOS_DIR" \
          -path "$NIXOS_DIR/.git" -prune -o \
          -type d -exec ${pkgs.coreutils-full}/bin/chmod 700 {} +

        # files: 600 (except .git)
        ${pkgs.findutils}/bin/find "$NIXOS_DIR" \
          -path "$NIXOS_DIR/.git" -prune -o \
          -type f -exec ${pkgs.coreutils-full}/bin/chmod 600 {} +

        # scripts explicitly executable
        ${pkgs.coreutils-full}/bin/chmod -R 700 "$NIXOS_DIR/cli"
  '';
in
{
  systemd.services.fix-nixos-dir-perms = {
    description = "Fix ownership and permissions of nixos directory";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        !${script}
      '';
    };
  };
}
