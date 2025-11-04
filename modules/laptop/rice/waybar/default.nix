{
  imports = [
    ./settings.nix

    ./start.nix

    ./style.nix
  ];

  programs.waybar.enable = true;
}
