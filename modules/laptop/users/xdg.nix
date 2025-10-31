{ vars, ... }:

{
  environment.sessionVariables = {
    XDG_DOCUMENTS_DIR = "/home/${vars.user.name}/Documents";
    XDG_DOWNLOAD_DIR = "/home/${vars.user.name}/Downloads";
    XDG_PICTURES_DIR = "/home/${vars.user.name}/Pictures";
  };
}
