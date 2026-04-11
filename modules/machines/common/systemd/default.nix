{
  imports = [
    ./disable-coredumps.nix
    ./disable-emergency.nix
    ./disable-rescue.nix
    ./journal.nix
    ./machineid.nix
    ./stage-1.nix
    ./timesyncd.nix
  ];
}
