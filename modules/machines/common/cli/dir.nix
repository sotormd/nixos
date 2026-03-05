{ config, pkgs, ... }:

let
  script = pkgs.writeShellScript "nixos-dir-perms" ''
    #!${pkgs.runtimeShell}

        DIR="/persist/nixos"
        USER=${config.vars.user.name}

        # chown directory
        ${pkgs.coreutils-full}/bin/chown $USER: -R $DIR

        # chown everything except .git
        ${pkgs.findutils}/bin/find "$DIR" \
          -path "$DIR/.git" -prune -o \
          -exec ${pkgs.coreutils-full}/bin/chown "$USER:$USER" {} +

        # directories: 700 (except .git)
        ${pkgs.findutils}/bin/find "$DIR" \
          -path "$DIR/.git" -prune -o \
          -type d -exec ${pkgs.coreutils-full}/bin/chmod 700 {} +

        # files: 600 (except .git)
        ${pkgs.findutils}/bin/find "$DIR" \
          -path "$DIR/.git" -prune -o \
          -type f -exec ${pkgs.coreutils-full}/bin/chmod 600 {} +

        # scripts explicitly executable
        ${pkgs.coreutils-full}/bin/chmod -R 700 "$DIR/cli"
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
