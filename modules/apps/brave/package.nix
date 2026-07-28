{
  symlinkJoin,
  executable,
  jail,
  ...
}:

let
  braveWrapped = symlinkJoin {
    name = "brave-wrapped";
    paths = [ executable ];

    # replace the brave executable with our wrapper
    postBuild = ''
      rm -f $out/bin/brave
      ln -s ${jail}/bin/brave $out/bin/brave
    '';
  };
in
braveWrapped
