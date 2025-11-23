{ vars, ... }:

let
  luks = vars.device.luks;

  luksNames = builtins.attrNames luks;

  luksList = builtins.map (name: luks.${name} // { inherit name; }) luksNames;

  crypttabText = builtins.concatStringsSep "\n" (
    builtins.map (entry: "${entry.name} UUID=${entry.uuid} ${entry.keyfile} luks,nofail") luksList
  );

  luksFS = builtins.listToAttrs (
    builtins.map (entry: {
      name = entry.mount;
      value = {
        device = "/dev/mapper/${entry.name}";
        fsType = entry.fs;
        options = [ "nofail" ];
      };
    }) luksList
  );
in
{
  environment.etc.crypttab.text = crypttabText;
  fileSystems = luksFS;
}
