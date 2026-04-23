{
  # prevent auditd logs from
  # getting absurdly large
  environment.etc."audit/auditd.conf" = {
    text = ''
      log_file = /var/log/audit/audit.log
      max_log_file = 500
      num_logs = 5
      max_log_file_action = ROTATE
      space_left = 200
      space_left_action = SYSLOG
      admin_space_left = 100
      admin_space_left_action = SUSPEND
    '';
  };

  # prevent the
  # kaudit backlog overflow
  boot.kernelParams = [
    "audit_backlog_limit=8192"
  ];
  security.audit.backlogLimit = 8192;
}
