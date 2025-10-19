{
  home.stateVersion = "24.05";

  home.sessionVariables.NIXOS_ROLE = "droid";
  home.sessionVariables.PS1 = ''\n\[\033[1;32m\]nix \w \$\[\033[0m\] '';

  home.file.".bashrc".text = ''
    alias switch="nix-on-droid switch --flake github:sotormd/nixos"
    alias purge="nix-collect-garbage --delete-old"
  '';
}
