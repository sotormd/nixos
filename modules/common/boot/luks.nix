{ vars, ... }:

let
  luks = vars.device.luks;

  luksNames = builtins.attrNames luks;

  luksList = builtins.map (name: luks.${name} // { inherit name; }) luksNames;

  # generate text to put in /etc/crypttab
  # based on vars.device.luks
  # see docs/laptop.md or docs/server.md
  crypttabText = builtins.concatStringsSep "\n" (
    builtins.map (entry: "${entry.name} UUID=${entry.uuid} ${entry.keyfile} luks,nofail") luksList
  );

  # generate fileSystems blocks to mount
  # partitions that were encrypted
  # see docs/laptop.md or docs/server.md
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
