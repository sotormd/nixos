{
  services.pipewire.wireplumber = {
    extraConfig = {
      # default volume is by default set to 0.4
      # instead set it to 0.0
      "10-default-volume" = {
        "wireplumber.settings"."device.routes.default-sink-volume" = 0.0;
      };
    };
  };
}
