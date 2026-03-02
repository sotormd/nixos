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
    "-w /var/log/lastlog -p wa -k logins"

    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268167
    # NixOS must generate audit records for all account creations, modifications, disabling, and termination events.
    "-w /etc/sudoers -p wa -k compliance-identity"
    "-w /etc/passwd -p wa -k compliance-identity"
    "-w /etc/shadow -p wa -k compliance-identity"
    "-w /etc/gshadow -p wa -k compliance-identity"
    "-w /etc/group -p wa -k compliance-identity"
    "-w /etc/security/opasswd -p wa -k compliance-identity"

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

    # https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268095
    # Successful/unsuccessful uses of the rename, unlink, rmdir, renameat, and unlinkat system calls in NixOS must generate an audit record.
    "-a always,exit -F arch=b32 -S rename,unlink,rmdir,renameat,unlinkat -F auid>=1000 -F auid!=unset -k compliance-delete"
    "-a always,exit -F arch=b64 -S rename,unlink,rmdir,renameat,unlinkat -F auid>=1000 -F auid!=unset -k compliance-delete"

    # https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268096
    # Successful/unsuccessful uses of the init_module, finit_module, and delete_module system calls in NixOS must generate an audit record.
    "-a always,exit -F arch=b32 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=unset -k compliance-module-chng"
    "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=unset -k compliance-module-chng"

    # https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268098
    # NixOS must generate an audit record for successful/unsuccessful uses of the truncate, ftruncate, creat, open, openat, and open_by_handle_at system calls.
    "-a always,exit -F arch=b32 -S open,creat,truncate,ftruncate,openat,open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=compliance-access"
    "-a always,exit -F arch=b32 -S open,creat,truncate,ftruncate,openat,open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=compliance-access"
    "-a always,exit -F arch=b64 -S open,creat,truncate,ftruncate,openat,open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=compliance-access"
    "-a always,exit -F arch=b64 -S open,creat,truncate,ftruncate,openat,open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=compliance-access"

    # https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268099
    # Successful/unsuccessful uses of the chown, fchown, fchownat, and lchown system calls in NixOS must generate an audit record.
    "-a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=1000 -F auid!=unset -F key=compliance-perm-mod"
    "-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=1000 -F auid!=unset -F key=compliance-perm-mod"

    # https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268100
    # Successful/unsuccessful uses of the chmod, fchmod, and fchmodat system calls in NixOS must generate an audit record.
    "-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=unset -k compliance-perm_mod"
    "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=unset -k compliance-perm-mod"

  ];
}
