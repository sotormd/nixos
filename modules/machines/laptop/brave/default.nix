{
  imports = [
    ./desktop.nix

    ./extensions.nix

    ./firejail.nix

    ./home.nix

    ./policies.nix

    ./sandbox.nix

    ./state.nix
  ];

  programs.chromium.enable = true;
}
