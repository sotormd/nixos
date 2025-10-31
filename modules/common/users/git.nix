{ vars, ... }:

{
  programs.git.enable = true;

  programs.git.config = {
    user.name = vars.user.name;
    user.email = vars.user.email;
  };
}
