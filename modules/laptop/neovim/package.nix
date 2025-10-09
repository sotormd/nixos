{ vars, neovim, ... }:

{
  home-manager.users.${vars.user.name} = {
    home.packages = [ neovim.packages.x86_64-linux.default ];
  };
}
