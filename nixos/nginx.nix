{ config, pkgs, lib, ... }: {
  services.nginx = {
    enable = true;
    virtualHosts."myhost.local" = {
      enableACME = true;
      forceSSL = true;
      root = "/home/rizqirazkafi/Document/learn/web";
      locations."~ \\.php$".extraConfig = ''
        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
        fastcgi_index index.php;
      '';
    };
  };
}
