{
  # shared memory access
  security.audit.rules = [
    "-a exit,never -F arch=b32 -F dir=/dev/shm -k sharedmemaccess"
    "-a exit,never -F arch=b64 -F dir=/dev/shm -k sharedmemaccess"
  ];
}
