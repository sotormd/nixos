{ inputs, vars, ... }:

{
  imports = [
    ./editor.nix
  ];

  users.users.${vars.user.name}.packages = [ inputs.neovim.packages.x86_64-linux.default ];
}
