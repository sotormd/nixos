{
  # disable coredumps which may leak sensitive information
  systemd.coredump.enable = false;
  security.pam.loginLimits = [
    {
      domain = "*"; # applies to all users/sessions
      type = "-"; # set both soft and hard limits
      item = "core"; # the soft/hard limit item
      value = "0"; # core dumps size is limited to 0 (effectively disabled)
    }
  ];
}
