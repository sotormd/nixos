{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  imports = [
    ./extensions.nix

    ./home.nix

    ./policies.nix

    ./preferences.nix

    ./state.nix
  ];

  programs.chromium.enable = true;
}
