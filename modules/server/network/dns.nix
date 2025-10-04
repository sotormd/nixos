{ vars, ... }:

{
  networking.nameservers =
    if (vars.network.unbound.enable == true) then
      [
        "127.0.0.1"
        "1.1.1.1"
        "1.0.0.1"
      ]
    else
      [
        "1.1.1.1"
        "1.0.0.1"
      ];
}
