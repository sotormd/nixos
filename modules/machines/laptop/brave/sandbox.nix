# run brave even if unprivileged namespaces are disabled
# this will NOT work inside a firejail
# so, running `brave` will not work
# instead, run the brave executable directly
# like this `$(cat $(which brave) | grep brave | awk '{print $17}')`
# this uses the SUID sandbox instead of namespaces
# but also doesn't work with firejail
# use at own risk

# disabled by default to avoid overusing suid

{
  config,
  lib,
  pkgs,
  ...
}:

{
  security.wrappers =
    if (config.boot.kernel.sysctl."kernel.unprivileged_userns_clone" == "0") then
      {
        chrome-sandbox-brave = {
          enable = lib.mkForce false; # disabled by default, avoid overusing suid
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
