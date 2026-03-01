{
  # disable automatic garbage collection
  nix.gc.automatic = false;

  # enable automatic deduplication
  nix.settings.auto-optimise-store = true;
}
