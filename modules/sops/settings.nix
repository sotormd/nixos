{
  sops.defaultSopsFile = ../../vars/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.gnupg.sshKeyPaths = [ ];
  sops.gnupg.home = "/persist/sops-nix";
}
