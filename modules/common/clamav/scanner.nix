{
  services.clamav.scanner.enable = false;
  services.clamav.scanner.scanDirectories = [
    "/persist"
    "/nix"
  ];
  services.clamav.scanner.interval = "Mon *-*-* 00:00:00";
}
