{
  imports = [
    ./disable-lecture.nix

    ./feedback.nix

    ./run0.nix

    ./suid-wrappers.nix

    ./users.nix
  ];

  # enable sudo
  security.sudo.enable = true;
}
