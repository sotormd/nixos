{
  config,
  inputs,
  pkgs,
  ...
}:

{
  hjem.users.${config.vars.user.name} = {
    enable = true;
    user = config.vars.user.name;
    directory = "/home/${config.vars.user.name}";
    clobberFiles = true;
  };

  hjem.clobberByDefault = true;

  hjem.linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
}
