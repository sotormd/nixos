{ pkgs, config, ... }:

{
  security.wrappers =
    if (config.boot.kernel.sysctl."kernel.unprivileged_userns_clone" == "0") then
      {
        chrome-sandbox-codium = {
          setuid = true;
          setgid = false;
          owner = "root";
          group = "root";
          source = "${pkgs.vscodium}/lib/vscode/chrome-sandbox";
        };
      }
    else
      { };
}
