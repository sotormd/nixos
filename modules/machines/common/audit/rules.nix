{
  security.audit.rules = [

    # log everytime a program is attempted to run
    "-a exit,always -F arch=b64 -S execve -k rules-run"

  ];
}
