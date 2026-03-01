{ config, ... }:

{
  environment.sessionVariables = {
    XDG_DOCUMENTS_DIR = "/home/${config.vars.user.name}/Documents";
    XDG_DOWNLOAD_DIR = "/home/${config.vars.user.name}/Downloads";
    XDG_PICTURES_DIR = "/home/${config.vars.user.name}/Pictures";
  };
}
