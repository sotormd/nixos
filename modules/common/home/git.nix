{ vars, ... }:

{
  # user information for git
  programs.git.enable = true;
  programs.git.userName = vars.user.name;
  programs.git.userEmail = vars.user.git.email;
}
