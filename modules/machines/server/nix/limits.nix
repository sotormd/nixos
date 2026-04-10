{
  # so that the raspberry pi doesn't explode
  nix.settings.max-jobs = 1;
  nix.settings.cores = 1;
}
