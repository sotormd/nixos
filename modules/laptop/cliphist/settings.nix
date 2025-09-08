{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    services.cliphist.allowImages = true;
  };
}
