{config, inputs, ...}: {
  age.secrets.nginx-passwords = {
    file = inputs.self + /secrets/nginx-passwords.age;
    mode = "770";
    owner = "nginx";
    group = "nginx";
  };

  services.nginx = let
    proxy = port: {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
    proxyRewrite = service: port:
      proxy port
      // {
        extraConfig = "rewrite ^/${service}/(.*) /$1 break;";
      };
  in {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    clientMaxBodySize = "20M";

    virtualHosts."127.0.0.1".locations = {
      "/" = {return = "301 /jellyfin/web/";};
      "/jellyfin" = proxy 8096;
      "/media" = {
        root = "/disks";
        basicAuthFile = config.age.secrets.nginx-passwords.path;
        extraConfig = "
          autoindex on;
          autoindex_format html;
          autoindex_exact_size off;
          autoindex_localtime on;
        ";
        };
      #"/ombi" = proxyRewrite "ombi" (toString config.services.ombi.port); # Get this to work
    };

    tailscaleAuth = {
      enable = true;
      expectedTailnet = "orca-pythagorean.ts.net";
      virtualHosts = ["helios"];
    };

    virtualHosts."helios".locations = 
      config.services.nginx.virtualHosts."127.0.0.1".locations
    // {
      "/" = proxy config.services.homepage-dashboard.listenPort;
      "/qbit" = proxyRewrite "qbit" config.services.qbittorrent.port;
      "/sonarr" = proxy 8989;
      "/prowlarr" = proxy 9696;
      "/radarr" = proxy 7878;
      "/readarr" = proxy 8787;
      "/scrutiny" = proxy config.services.scrutiny.settings.web.listen.port;
      "/grafana" = proxy config.services.grafana.settings.server.http_port;
      "/influx" = proxy 8086;
    };
  };
}