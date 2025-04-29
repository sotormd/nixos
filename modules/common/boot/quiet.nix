{
  # options for achieving a silent or "quiet" boot
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

  boot.kernel.sysctl = {
    "kernel.printk" = "3 3 3 3";
  };
}
