{ vars, ... }:

{
  networking.nameservers =
    if (vars.network.server.enable == true) then
      [
        "192.168.0.37"
        "1.1.1.1"
        "1.0.0.1"
      ]
    else
      [
        "1.1.1.1"
        "1.0.0.1"
      ];
}
