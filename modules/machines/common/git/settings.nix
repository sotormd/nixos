{ config, ... }:

{
  programs.git.config = {
    user.name = config.vars.user.name;
    user.email = config.vars.user.email;
  };
}
