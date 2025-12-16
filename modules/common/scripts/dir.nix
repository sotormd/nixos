{ vars, pkgs, ... }:

let
  script = pkgs.writeShellScript "nixos-dir-perms" ''
    #!/usr/bin/env bash

        NIXOS_DIR=${vars.nixosDirectory}
        USER=${vars.user.name}

        # chown everything except .git
        ${pkgs.findutils}/bin/find "$NIXOS_DIR" \
          -path "$NIXOS_DIR/.git" -prune -o \
          -exec ${pkgs.coreutils}/bin/chown "$USER:$USER" {} +

        # directories: 700 (except .git)
        ${pkgs.findutils}/bin/find "$NIXOS_DIR" \
          -path "$NIXOS_DIR/.git" -prune -o \
          -type d -exec ${pkgs.coreutils}/bin/chmod 700 {} +

        # files: 600 (except .git)
        ${pkgs.findutils}/bin/find "$NIXOS_DIR" \
          -path "$NIXOS_DIR/.git" -prune -o \
          -type f -exec ${pkgs.coreutils}/bin/chmod 600 {} +

        # scripts explicitly executable
        ${pkgs.coreutils}/bin/chmod -R 700 "$NIXOS_DIR/scripts"
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
