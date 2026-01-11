{ pkgs, ... }:

{
  # use lix for package management
  # instead of cppnix
  # why? idk i forgot

  # see https://lix.systems

  nix.package = pkgs.lix;
}
