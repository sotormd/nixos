{
  imports = [
    # MODULES - sorted alphabetically

    # terminal colors
    ./colors.nix

    # packages
    ./packages.nix

    # switch & purge
    ./scripts.nix
  ];

  environment.etcBackupExtension = ".bak";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.sessionVariables = {
    NIXOS_ROLE = "droid";
    PS1 = ''\n\[\033[1;32m\]nix \w λ\[\033[0m\] '';
  };

  environment.motd = ''
    nix-on-droid
  '';
}
