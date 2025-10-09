{ vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    home.sessionVariables.EDITOR = "vi";
  };
}
