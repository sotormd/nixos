{
  security.audit.rules = [

    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268165
    # NixOS must generate audit records when successful/unsuccessful attempts to delete security objects occur.
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268163
    # NixOS must generate audit records when successful/unsuccessful attempts to modify security objects occur.
    "-a always,exit -F path=/run/current-system/sw/bin/chage -F perm=x -F auid>=1000 -F auid!=unset -k compliance-privileged-chage"
    "-a always,exit -F path=/run/current-system/sw/bin/chcon -F perm=x -F auid>=1000 -F auid!=unset -k compliance-perm-mod"
    "-a always,exit -F arch=b32 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid>=1000 -F auid!=-1 -k compliance-perm-mod"
    "-a always,exit -F arch=b32 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid=0 -k compliance-perm-mod"
    "-a always,exit -F arch=b64 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid>=1000 -F auid!=-1 -k compliance-perm-mod"
    "-a always,exit -F arch=b64 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid=0 -k compliance-perm-mod"

    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268164
    # NixOS must generate audit records when successful/unsuccessful attempts to delete privileges occur.
    "-a always,exit -F path=/run/current-system/sw/bin/usermod -F perm=x -F auid>=1000 -F auid!=unset -k compliance-privileged-usermod"

    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268166
    # NixOS must generate audit records when concurrent logins to the same account occur from different sources.
    # "-w /var/log/lastlog -p wa -k logins"
    "-a always,exit -F path=/var/log/lastlog -F perm=wa -F key=logins"

    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268167
    # NixOS must generate audit records for all account creations, modifications, disabling, and termination events.
    # "-w /etc/sudoers -p wa -k compliance-identity"
    # "-w /etc/passwd -p wa -k compliance-identity"
    # "-w /etc/shadow -p wa -k compliance-identity"
    # "-w /etc/gshadow -p wa -k compliance-identity"
    # "-w /etc/group -p wa -k compliance-identity"
    # "-w /etc/security/opasswd -p wa -k compliance-identity"
    "-a always,exit -F path=/etc/passwd -F perm=wa -F key=compliance-identity"
    "-a always,exit -F path=/etc/shadow -F perm=wa -F key=compliance-identity"
    "-a always,exit -F path=/etc/group -F perm=wa -F key=compliance-identity"
    "-a always,exit -F path=/etc/gshadow -F perm=wa -F key=compliance-identity"
    "-a always,exit -F path=/etc/sudoers -F perm=wa -F key=compliance-identity"
    "-a always,exit -F path=/etc/security/opasswd -F perm=wa -F key=compliance-identity"

    # https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268094
    # Successful/unsuccessful uses of the mount syscall in NixOS must generate an audit record.
    "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=unset -k compliance-privileged-mount"
    "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=unset -k compliance-privileged-mount"

    # https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268091
    # NixOS must generate audit records for all usage of privileged commands.
    "-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k compliance-execpriv"
    "-a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -k compliance-execpriv"
    "-a always,exit -F arch=b32 -S execve -C gid!=egid -F egid=0 -k compliance-execpriv"
    "-a always,exit -F arch=b64 -S execve -C gid!=egid -F egid=0 -k compliance-execpriv"

    # https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268096
    # Successful/unsuccessful uses of the init_module, finit_module, and delete_module system calls in NixOS must generate an audit record.
    "-a always,exit -F arch=b32 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=unset -k compliance-module-chng"
    "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=unset -k compliance-module-chng"

  ];
}
