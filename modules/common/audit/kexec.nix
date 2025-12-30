{
  # kexec
  security.audit.rules = [
    "-a always,exit -F arch=b64 -S kexec_load -F key=KEXEC"
    #    "-a always,exit -F arch=b32 -S sys_kexec_load -k KEXEC" # breaks on server
  ];
}
