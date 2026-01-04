{ pkgs, vars, ... }:

{
  # Rollback /home
  boot.initrd.systemd.services.rollback-home = {
    description = "Rollback /home";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    path = with pkgs; [ zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r rpool/home@blank
    '';
  };

  # Setup /home
  systemd.services.setup-home = {
    description = "Setup /home";
    wantedBy = [ "local-fs.target" ];
    after = [
      "rollback-home.service"
      "home.mount"
    ];
    before = [ "hjem-activate@${vars.user.name}.service" ];
    path = with pkgs; [ coreutils ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /home/${vars.user.name}/.config
      chown ${vars.user.name}: -R /home/${vars.user.name}
    '';
  };
}
