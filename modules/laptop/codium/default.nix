{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  imports = [
    ./extensions.nix

    ./settings.nix

    ./updates.nix
  ];

  home-manager.users."${vars.user.name}" = {
    programs.vscode.enable = true;
    programs.vscode.package = pkgs.vscodium;
  };
}
