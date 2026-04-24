{
  security.audit.rules = [

    # log everytime a program is attempted to run
    "-a exit,always -S execve -k rules-run"

  ];
}
