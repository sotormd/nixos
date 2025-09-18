{ vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    programs.vscode.profiles.default.enableUpdateCheck = false;
    programs.vscode.profiles.default.enableExtensionUpdateCheck = false;
  };
}
