{ pkgs, vars, ... }:

let
  package = import ./package.nix { inherit pkgs vars; };
in
{
  programs.firejail.wrappedBinaries.i2p-browser = {
    executable = "${package.policiesFirefox}/bin/firefox";
    profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    extraArgs = [ "--nonewprivs" ];
  };
}
