{ config, ... }:

{
  programs.git.config = {
    user.name = config.vars.user.git.name;
    user.email = config.vars.user.git.email;
    user.signingKey = config.vars.user.git.signing-key;
    gpg.format = "ssh";
    gpg.ssh.allowedSignersFile = config.vars.user.git.allowed-signers;
    commit.gpgSign = true;
  };
}
