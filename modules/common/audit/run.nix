{
  # log everytime a program is attempted to run
  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
  ];
}
