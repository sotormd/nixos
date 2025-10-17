{ lib, vars, ... }:

{
  imports = lib.concatMap (x: x) [
    [
      ./disable-ipv6.nix

      ./firewall.nix

      ./host.nix

      ./issue.nix

      ./static.nix

      ./wifi.nix
    ]

    (lib.optImport vars.network.wpa3.enable ./wpa3.nix)
  ];
}
