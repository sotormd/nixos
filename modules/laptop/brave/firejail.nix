{
  pkgs,
  config,
  colors,
  vars,
  ...
}:

let
  package = import ./package.nix { inherit pkgs config colors; };
in
{
  programs.firejail.wrappedBinaries.brave = {
    executable = "${package.customBrave}/bin/brave";
    profile = "${pkgs.firejail}/etc/firejail/brave.profile";
    extraArgs = [
      "--nonewprivs"
      "--whitelist=/home/${vars.user.name}/.local/share/home.html"
    ];
  };
}
