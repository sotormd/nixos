{
  # log everytime a program is attempted to run
  security.audit.rules = [
    "-a exit,always -F arch=b64 -F euid=0 -S execve"
    "-a exit,always -F arch=b32 -F euid=0 -S execve"
    "-a exit,always -F arch=b64 -F euid=0 -S execveat"
    "-a exit,always -F arch=b32 -F euid=0 -S execveat"

    "-a exit,always -F arch=b64 -S execve -F key=progexec"

    "-a always,exit -F arch=b64 -F euid=0 -F auid>=1000 -F auid!=-1 -S execve -F key=rootcmd"
  ];
}
