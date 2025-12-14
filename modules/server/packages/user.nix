{ pkgs, vars, ... }:

{
  # set of packages to appear in user environment
  users.users.${vars.user.name}.packages = with pkgs; [
    # vim - vi improved
    vim
  ];

  environment.sessionVariables.EDITOR = "vi";
}
