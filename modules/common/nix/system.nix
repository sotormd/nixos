{ self, ... }:

{
  # place the flake that built the current configuration
  # in /etc/current-flake, for ease-of-use with tools
  # like nixos-enter, in case the flake contains
  # changes that have not been staged yet
  environment.etc."current-flake".source = self;
}
