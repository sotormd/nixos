{
  # settings for the nix package manager
  nix.settings = {

    # enable experimental features
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # only allow members of the wheel group
    # to use the nix package manager
    allowed-users = [ "@wheel" ];

    # only trust the root user
    trusted-users = [ "root" ];

    # download only cryptographically signed binaries
    # preventing MITM attacks
    require-sigs = true;

    # deny IFDs which slow down evaluation
    allow-import-from-derivation = false;

    # deny flake-config which can inject
    # unsafe configurations into nix
    accept-flake-config = false;

    # do not warn about dirty git trees
    warn-dirty = false;

    # enable automatic deduplication
    auto-optimise-store = true;

    # no need for the global flake registry
    flake-registry = null;

  };

  # do not automatically run gc
  nix.gc.automatic = false;
}
