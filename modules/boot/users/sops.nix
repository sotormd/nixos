{ sops, ... }:

{
  sops = {
    keepGenerations = 0;
    defaultSopsFile = sops;
    defaultSopsFormat = "yaml";
    gnupg.sshKeyPaths = [ ];
    gnupg.home = "/persist/sops-nix";
    secrets = {
      hashedPassword = {
        neededForUsers = true;
      };
    };
  };

  programs.gnupg.agent.enable = true;
}
