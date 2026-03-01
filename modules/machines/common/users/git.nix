{ config, ... }:

{
  # version control that doesn't suck
  programs.git.enable = true;

  programs.git.config = {
    user.name = config.vars.user.name;
    user.email = config.vars.user.email;
  };
}
