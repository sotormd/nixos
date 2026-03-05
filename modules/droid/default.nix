{ inputs, pkgs, ... }:

{
  imports = [
    # nixos modules
    inputs.colors.nixosModules.colors

    # MODULES - sorted alphabetically

    # terminal colors
    ./colors.nix

    # packages
    ./packages.nix

    # switch & purge
    ./scripts.nix
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.package = pkgs.lix;

  environment = {

    etcBackupExtension = ".bak";

    sessionVariables = {
      NIXOS_ROLE = "droid";
      PS1 = ''\n\[\033[1;32m\][\w] λ\[\033[0m\] '';
    };

    motd = ''
      nix-on-droid
    '';

  };
}
