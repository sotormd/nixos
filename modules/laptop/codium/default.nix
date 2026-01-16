{ vars, ... }:

{
  imports = [
    ./extensions.nix

    ./firejail.nix

    ./sandbox.nix

    ./settings.nix

    ./updates.nix
  ];

  home-manager.users.${vars.user.name} = {
    programs.vscode.enable = true;
  };
}
