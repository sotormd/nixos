{ pkgs, vars, ... }:

{
  users.users.${vars.user.name}.packages = [
    (pkgs.makeDesktopItem {
      name = "org.pwmt.zathura";
      desktopName = "Zathura";
      genericName = "Document Viewer";
      comment = "A minimalistic document viewer";
      exec = "zathura %U";
      icon = "org.pwmt.zathura";
      terminal = false;
      categories = [
        "Office"
        "Viewer"
      ];
      mimeTypes = [
        "application/pdf"
        "image/vnd.djvu"
        "application/postscript"
      ];

      extraConfig = {
        Keywords = "PDF;PS;PostScript;DjVU;document;presentation;viewer;";
      };
    })
  ];
}
