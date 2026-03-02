{
  # disable timesyncd
  services.timesyncd.enable = false;

  # grapheneOS/secureblue NTS chrony settings
  services.chrony = {
    enable = true;
    enableNTS = true;

    servers = [
      "time.cloudflare.com"
    ];

    # kinda breaks:
    #  extraConfig = ''
    #      minsources 3
    #      authselectmode require

    #      # EF
    #      dscp 46

    #      driftfile /var/lib/chrony/drift
    #      dumpdir /var/lib/chrony
    #      ntsdumpdir /var/lib/chrony

    #      leapseclist /usr/share/zoneinfo/leap-seconds.list
    #      makestep 1.0 3

    #      rtconutc

    #      cmdport 0

    #      noclientlog
    #  '';
  };
}
