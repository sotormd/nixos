{ pkgs, vars, ... }:

{
  users.users.${vars.user.name}.packages = [ pkgs.python3 ];
}
