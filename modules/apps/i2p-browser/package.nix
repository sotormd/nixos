{
  symlinkJoin,
  jail,
  desktop,
  ...
}:

let
  i2pBrowser = symlinkJoin {
    name = "i2p-browser";
    paths = [
      jail
      desktop
    ];
  };
in
i2pBrowser
