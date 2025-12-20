{ inputs, ... }:

{
  imports = [ inputs.hosts.nixosModule ];

  networking.stevenBlackHosts = {
    enable = true;
    blockFakenews = true;
    blockGambling = true;
    blockPorn = true;
    blockSocial = false;
  };
}
