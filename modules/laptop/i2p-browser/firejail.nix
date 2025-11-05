{ pkgs, vars, ... }:

let
  package = import ./package.nix { inherit pkgs vars; };
in
{
  programs.firejail.wrappedBinaries.i2p-browser = {
    executable = "${package.i2pBrowser}/bin/i2p-browser";
    profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    extraArgs = [ "--nonewprivs" ];
  };
}
