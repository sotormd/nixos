{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    # disable imperative extension management
    programs.vscode.mutableExtensionsDir = false;

    # list of extensions
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-python.python
      rust-lang.rust-analyzer
      jnoortheen.nix-ide
      arcticicestudio.nord-visual-studio-code
      pkief.material-icon-theme
    ];
  };
}
