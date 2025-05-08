{ vars, ... }:

{
  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    appendHttpConfig = ''
      error_log syslog:server=unix:/dev/log;
      access_log syslog:server=unix:/dev/log combined;
    '';
  };

  services.nginx.virtualHosts."${vars.network.duckdns.domain}" = {
    locations."/" = {
      return = "200 '<html><body>nixos server ${vars.device.hostName}</body></html>'";
      extraConfig = ''
        default_type text/html;
      '';
    };
  };
}
