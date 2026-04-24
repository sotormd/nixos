{ config, ... }:

let
  inherit (config.vars.filesystem) luks;

  luksNames = builtins.attrNames luks;

  luksList = map (name: luks.${name} // { inherit name; }) luksNames;

  # generate text to put in /etc/crypttab
  crypttabText = builtins.concatStringsSep "\n" (
    map (entry: "${entry.name} UUID=${entry.uuid} ${entry.keyfile} luks,nofail,timeout=0") luksList
  );
in
{
  environment.etc.crypttab.text = crypttabText;
}
