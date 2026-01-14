{ config, ... }:

{
  # configuration for the main user and their group

  users.users."${config.vars.user.name}" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;

    group = config.vars.user.name;
    extraGroups = [ "wheel" ];

    home = "/home/${config.vars.user.name}";
    createHome = true;
  };

  users.groups = {
    "${config.vars.user.name}" = { };
  };
}
