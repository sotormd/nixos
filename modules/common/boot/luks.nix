{ config, ... }:

let
  luks = config.vars.device.luks;

  luksNames = builtins.attrNames luks;

  luksList = builtins.map (name: luks.${name} // { inherit name; }) luksNames;

  # generate text to put in /etc/crypttab
  # based on config.vars.device.luks
  crypttabText = builtins.concatStringsSep "\n" (
    builtins.map (entry: "${entry.name} UUID=${entry.uuid} ${entry.keyfile} luks,nofail") luksList
  );
in
{
  environment.etc.crypttab.text = crypttabText;
}
