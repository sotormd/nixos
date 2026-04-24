{
  # use Steven Black's hostlists
  # to block bad content
  networking.stevenBlackHosts = {
    enable = true;
    enableIPv6 = false;
    blockFakenews = true;
    blockGambling = true;
    blockPorn = true;
    blockSocial = true;
  };
}
