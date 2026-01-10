{
  # disable the sudo "lecture"
  # usually this message:

  # We trust you have received the usual lecture from the local System
  # Administrator. It usually boils down to these three things:
  #
  #  1) Respect the privacy of others.
  #  2) Think before you type.
  #  3) With great power comes great responsibility.

  # the message will be disabled after the first lecture
  # but due to impermanence, it will show up again
  # every time sudo is used after a reboot

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
