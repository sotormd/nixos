{
  # set contents of /etc/issue
  # in accordance with a lynis report
  environment.etc."issue".text = ''
    \e[1;32mWARNING: Unauthorized access to this system is prohibited.\e[0m

    \l

  '';
}
