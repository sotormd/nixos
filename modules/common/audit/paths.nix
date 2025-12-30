{
  security.audit.rules = [
    "-w /var/log/audit/ -k auditlog"

    "-a always,exit -F arch=b64 -F dir=/home -F perm=war -F key=homeaccess"

    "-a always,exit -F arch=b64 -S open,creat -F exit=-EACCES -k access"
    "-a always,exit -F arch=b64 -S open,creat -F exit=-EPERM -k access"
    "-a always,exit -F arch=b32 -S open,creat -F exit=-EACCES -k access"
    "-a always,exit -F arch=b32 -S open,creat -F exit=-EPERM -k access"
    "-a always,exit -F arch=b64 -S openat -F exit=-EACCES -k access"
    "-a always,exit -F arch=b64 -S openat -F exit=-EPERM -k access"
    "-a always,exit -F arch=b32 -S openat -F exit=-EACCES -k access"
    "-a always,exit -F arch=b32 -S openat -F exit=-EPERM -k access"
    "-a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EACCES -k access"
    "-a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EPERM -k access"
    "-a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EACCES -k access"
    "-a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EPERM -k access"

    "-a always,exit -F arch=b64 -S open -F dir=/etc -F success=0 -F key=unauthedfileaccess"
    "-a always,exit -F arch=b64 -S open -F dir=/bin -F success=0 -F key=unauthedfileaccess"
    "-a always,exit -F arch=b64 -S open -F dir=/var -F success=0 -F key=unauthedfileaccess"
    "-a always,exit -F arch=b64 -S open -F dir=/home -F success=0 -F key=unauthedfileaccess"
    "-a always,exit -F arch=b64 -S open -F dir=/srv -F success=0 -F key=unauthedfileaccess"
    "-a always,exit -F arch=b64 -S open -F dir=/boot -F success=0 -F key=unauthedfileaccess"
    "-a always,exit -F arch=b64 -S open -F dir=/nix -F success=0 -F key=unauthedfileaccess"

    "-a always,exit -F arch=b64 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=-1 -F key=delete"
  ];
}
