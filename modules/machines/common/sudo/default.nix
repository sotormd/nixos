{
  imports = [
    ./disable-lecture.nix

    ./feedback.nix

    ./users.nix
  ];

  # enable sudo
  security.sudo.enable = true;
}
