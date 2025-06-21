{ pkgs, config, ... }:

{
  security.wrappers =
    if (config.boot.kernel.sysctl."kernel.unprivileged_userns_clone" == "0") then
      {
        chrome-sandbox-brave = {
          setuid = true;
          setgid = false;
          owner = "root";
          group = "root";
          source = "${pkgs.brave}/opt/brave.com/brave/chrome-sandbox";
        };
      }
    else
      { };
}
