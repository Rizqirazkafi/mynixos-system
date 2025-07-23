{ pkgs, lib, config, ... }:
let
  appUser = "phpdemo";
  domain = "${appUser}.local";
  dataDir = "/var/www";
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.phpfpm.pools.${appUser} = {
    # user = appUser;
    user = "rizqirazkafi";
    group = "nginx";
    settings = {
      "listen" = config.services.phpfpm.pools.${appUser}.socket;
      "listen.owner" = config.services.nginx.user;
      "listen.group" = config.services.nginx.group;
      "listen.mode" = "0660";
      "pm" = "dynamic";
      "pm.max_children" = 75;
      "pm.start_servers" = 10;
      "pm.min_spare_servers" = 5;
      "pm.max_spare_servers" = 20;
      "pm.max_requests" = 500;
      "catch_workers_output" = 1;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      ${domain} = {
        root = "${dataDir}";

        extraConfig = "index index.html index.php; charset utf-8;";

        locations."/" = {
          extraConfig = ''
            # First attempt to serve request as file, then
            # as directory, then fall back to displaying a 404.

            try_files $uri $uri/ /index.php$is_args$args;		
            # error_page 404 /index.php;

            autoindex on;
          '';
        };

        locations."~ \\.php" = {
          extraConfig = ''
            fastcgi_split_path_info ^(.+\\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.${appUser}.socket};
            # fastcgi_index index.php;
            # fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            # include ${config.services.nginx.package}/conf/fastcgi_params;
            include ${pkgs.nginx}/conf/fastcgi.conf;


          '';
        };
      };
    };
  };
  # users.users.${appUser} = {
  #   isSystemUser = true;
  #   home = dataDir;
  #   group = appUser;
  # };
  # users.groups.${appUser} = { };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  systemd.services.mysql.wantedBy = lib.mkForce [ ];
  systemd.services.nginx.wantedBy = lib.mkForce [ ];
  systemd.services.nginx.serviceConfig.ProtectHome = lib.mkForce false;
  systemd.services.phpfpm-phpdemo.serviceConfig.ProtectHome = lib.mkForce false;
  systemd.services.phpfpm-phpdemo.wantedBy = lib.mkForce [ ];
  systemd.services.phpfpm-phpdemo.serviceConfig.ReadWritePaths =
    [ "/home/rizqirazkafi/Documents/github/form-penjurusan" ];
}
