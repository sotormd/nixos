{ config, inputs, ... }:

{
  users.users.${config.vars.user.name}.packages = [ inputs.neovim.packages.x86_64-linux.default ];
}
