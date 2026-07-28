{
  brave,
  symlinkJoin,
  jail,
  ...
}:

let
  braveWrapped = symlinkJoin {
    name = "brave-wrapped";
    paths = [ brave ];

    postBuild = ''
      rm -f $out/bin/brave
      ln -s ${jail}/bin/brave $out/bin/brave
    '';
  };
in
braveWrapped
