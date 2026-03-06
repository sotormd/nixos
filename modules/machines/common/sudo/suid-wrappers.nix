{ lib, ... }:

{
  # disable suid wrappers
  # for unused binaries
  security.wrappers = {
    su.enable = lib.mkForce false;
    sg.enable = lib.mkForce false;
    pkexec.enable = lib.mkForce false;
  };
}
