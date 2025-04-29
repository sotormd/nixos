{ config, vars, ... }:

{
  users.users."${vars.user.name}" = {
    isNormalUser = true;
    home = "/home/${vars.user.name}";
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
  };
}
