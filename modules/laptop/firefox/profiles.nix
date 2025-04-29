{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    programs.firefox.profiles."${vars.user.name}" = {
      name = vars.user.name;
      id = 0;
      isDefault = true;
    };
  };
}
