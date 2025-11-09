{
  inputs,
  pkgs,
  vars,
  ...
}:

{
  hjem.users.${vars.user.name} = {
    enable = true;
    user = vars.user.name;
    directory = "/home/${vars.user.name}";
    clobberFiles = true;
  };

  hjem.clobberByDefault = true;

  hjem.linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
}
