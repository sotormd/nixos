{
  # prevent journald log froms
  # getting absurdly large
  services.journald.extraConfig = ''
    SystemMaxUse=2G
    RuntimeMaxUse=2G
  '';
}
