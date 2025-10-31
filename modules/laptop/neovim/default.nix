{ vars, neovim, ... }:

{
  imports = [
    ./editor.nix
  ];

  users.users.${vars.user.name}.packages = [ neovim.packages.x86_64-linux.default ];
}
