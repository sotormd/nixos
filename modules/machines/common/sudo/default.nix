{
  imports = [
    ./disable-lecture.nix

    ./feedback.nix

    ./suid-wrappers.nix

    ./users.nix
  ];

  # enable sudo
  security.sudo.enable = true;
}
