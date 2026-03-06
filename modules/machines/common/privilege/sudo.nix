{

  security.sudo = {

    # enable sudo
    enable = true;

    # extra config:

    # 1.
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

    # 2.
    # enable sudo password feedback
    # show password as asterisks while entering

    extraConfig = ''
      Defaults lecture = never
      Defaults pwfeedback
    '';

    # require password for members of wheel group
    wheelNeedsPassword = true;

    # only allow members of wheel group to execute sudo
    execWheelOnly = true;

  };

}
