{
  symlinkJoin,
  jail,
  desktop,
}:

let
  i2p-browser = symlinkJoin {
    name = "i2p-browser";
    paths = [
      jail.jail
      desktop
    ];
  };

  i2p-browser-adhoc = jail.jail-adhoc;
in
{
  inherit i2p-browser i2p-browser-adhoc;
}
