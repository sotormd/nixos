{
  # download only cryptographically signed binaries, preventing MITM attacks
  nix.settings.require-sigs = true;
}
