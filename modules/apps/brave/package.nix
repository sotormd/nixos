{
  symlinkJoin,
  jail,
  desktop,
  ...
}:

let
  brave = symlinkJoin {
    name = "brave";
    paths = [
      jail
      desktop
    ];
  };
in
brave
