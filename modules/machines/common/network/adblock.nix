{ inputs, ... }:

{
  imports = [ inputs.hosts.nixosModule ];

  # use Steven Black's hostlists
  # to block bad content
  networking.stevenBlackHosts = {
    enable = true;
    blockFakenews = true;
    blockGambling = true;
    blockPorn = true;
    blockSocial = false;
  };
}
