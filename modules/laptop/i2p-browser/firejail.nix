{
  config,
  pkgs,
  lib,
  ...
}:

let
  package = import ./package.nix { inherit config pkgs; };
in
{
  programs.firejail.wrappedBinaries.i2p-browser = lib.mkIf config.vars.network.server.enable {
    executable = "${package.i2pBrowser}/bin/i2p-browser";
    profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    extraArgs = [
      "--nonewprivs"

      "--caps.drop=all"

      "--no3d"
      "--nodbus"
      "--nodvd"
      "--nogroups"
      "--noprinters"
      "--noroot"
      "--nosound"
      "--nou2f"
      "--novideo"

      "--private-cache"
      "--private-cwd"
      "--private-dev"
      "--private-etc"
      "--private-tmp"

      "--seccomp"
    ];
  };
}
