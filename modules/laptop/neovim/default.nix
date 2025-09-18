{
  imports = [
    ./clipboard.nix

    ./colorscheme.nix

    ./keymaps.nix

    ./plugins.nix

    ./settings.nix
  ];

  programs.nixvim.enable = true;
}
