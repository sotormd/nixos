{ lib, ... }:

{
  security.wrappers = {
    su.enable = lib.mkForce false;
    sudoedit.enable = lib.mkForce false;
    sg.enable = lib.mkForce false;
    pkexec.enable = lib.mkForce false;
  };
}
