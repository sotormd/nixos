{ vars, ... }:

{
  services.nginx.virtualHosts."${vars.network.duckdns.domain}" = {
    locations."/i2pd/" = {
      proxyPass = "http://127.0.0.1:${toString vars.network.i2pd.webconsole.port}";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        sub_filter_once off;
        sub_filter '/?' '/i2pd/?';
        sub_filter 'href="/' 'href="/i2pd/';
        sub_filter 'action="/' 'action="/i2pd/';
        sub_filter 'src="/' 'src="/i2pd/';
      '';
    };
  };
}
