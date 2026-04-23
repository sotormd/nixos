{
  # use jitterentropy for a decent entropy source
  # collects CPU executing time jitter to generate
  # "true" random numbers
  services.jitterentropy-rngd.enable = true;
}
