{ pkgs, vars, ... }:

{
  # Rollback /home
  boot.initrd.systemd.services.rollback-home = {
    description = "Rollback /home";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      "zfs-import-rpool.service"
    ];
    before = [
      "sysroot.mount"
    ];
    path = with pkgs; [
      zfs
    ];
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
    before = [
      "home-manager-${vars.user.name}.service"
    ];
    path = with pkgs; [
      coreutils
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /home/${vars.user.name}/.config
      chown ${vars.user.name}:users -R /home/${vars.user.name}
    '';
  };

  # Persist files on /home
  # Desktop directory
  fileSystems."/home/${vars.user.name}/Desktop" = {
    device = "/persist/root/home/${vars.user.name}/Desktop";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Documents directory
  fileSystems."/home/${vars.user.name}/Documents" = {
    device = "/persist/root/home/${vars.user.name}/Documents";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Downloads directory
  fileSystems."/home/${vars.user.name}/Downloads" = {
    device = "/persist/root/home/${vars.user.name}/Downloads";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Pictures directory
  fileSystems."/home/${vars.user.name}/Pictures" = {
    device = "/persist/root/home/${vars.user.name}/Pictures";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Projects directory
  fileSystems."/home/${vars.user.name}/Projects" = {
    device = "/persist/root/home/${vars.user.name}/Projects";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # GPG directory
  fileSystems."/home/${vars.user.name}/.gnupg" = {
    device = "/persist/root/home/${vars.user.name}/.gnupg";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # SSH directory
  fileSystems."/home/${vars.user.name}/.ssh" = {
    device = "/persist/root/home/${vars.user.name}/.ssh";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Firefox directory
  fileSystems."/home/${vars.user.name}/.mozilla" = {
    device = "/persist/root/home/${vars.user.name}/.mozilla";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Codium directories
  fileSystems."/home/${vars.user.name}/.vscode-oss" = {
    device = "/persist/root/home/${vars.user.name}/.vscode-oss";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  fileSystems."/home/${vars.user.name}/.config/VSCodium" = {
    device = "/persist/root/home/${vars.user.name}/.config/VSCodium";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };
}
