{ config, vars, ... }:

{
  users.users."${vars.user.name}" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;

    group = vars.user.name;
    extraGroups = [ "wheel" ];

    home = "/home/${vars.user.name}";
    createHome = true;
  };

  users.groups = {
    "${vars.user.name}" = { };
  };
}
