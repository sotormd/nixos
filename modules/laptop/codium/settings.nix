{ vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    programs.vscode.profiles.default.userSettings = {
      "files.autoSave" = "afterDelay";
      "editor.fontFamily" = "IBM Plex Mono";
      "editor.fontSize" = 12;
      "terminal.integrated.fontSize" = 12;
      "window.menuBarVisibility" = "toggle";
      "window.customMenuBarAltFocus" = false;
      "window.enableMenuBarMnemonics" = false;
      "workbench.welcomePage.walkthroughs.openOnInstall" = false;
      "workbench.welcomePage.extraAnnouncements" = false;
      "workbench.startupEditor" = "newUntitledFile";
      "workbench.colorTheme" = "Nord";
      "workbench.iconTheme" = "material-icon-theme";
      "window.customTitleBarVisibility" = "never";
      "window.titleBarStyle" = "native";
    };
  };
}
