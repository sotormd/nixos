{
  lib,
  mousepad,
  callPackage,
  configuration,
  vars,
}:

let
  user = vars.user.name;
  home = "/home/${user}";

  name = "mousepad";
  base = mousepad;
  binds = [
    {
      src = configuration;
      dst = "${home}/.config/Mousepad/settings.conf";
    }
  ];

  mousepadWrapped = callPackage lib.mkTrivialBwrapWrapper { inherit name base binds; };
in
mousepadWrapped
