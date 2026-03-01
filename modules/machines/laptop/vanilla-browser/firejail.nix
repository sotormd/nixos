{ pkgs, ... }:

let
  package = import ./package.nix { inherit pkgs; };
in
{
  programs.firejail.wrappedBinaries.vanilla-browser = {
    executable = "${package.chromium}/bin/chromium";
    profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
    extraArgs = [
      "--nonewprivs"

      "--private"

      "--caps.drop=all"

      "--noroot"

      "--private-cache"
      "--private-cwd"
      "--private-dev"
      "--private-etc"
      "--private-tmp"
    ];
  };
}
