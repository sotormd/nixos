{
  # configuration for nixpkgs
  nixpkgs.config = {

    # ensure packages marked as broken
    # refuse to evaluate and build
    allowBroken = false;

    # ensure packages marked as unfree
    # refuse to evaluate and build
    #
    # you can still use unfree packages
    # by installing them in an impure shell
    #
    # $ export NIXPKGS_ALLOW_UNFREE=1
    # $ nix shell nixpkgs#spotify --impure
    #
    allowUnfree = false;

    # ensure packages marked as unsupported
    # for the current build system architecture
    # refuse to evaluate and build
    allowUnsupportedSystem = false;

  };
}
