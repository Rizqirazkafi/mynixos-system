{pkgs, config, ...}: 
{

  services.postgresql = {
    enable = true;
  };
  services.nginx.enable = true;
  services.nginx.virtualHosts."siaga.org" = {
    root = "/var/www/myhost.org";
  };

}
