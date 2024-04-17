{ config, ... }:
let
  logFormat = "output stderr";
in
{
  services.caddy = {
    enable = true;
    email = "webmaster@kj4jzy.org";
    extraConfig = ''
      (standard_headers) {
        encode zstd gzip
        header Strict-Transport-Security max-age=15768000
      }
    '';
    virtualHosts = {
      "kj4jzy.org" = {
        inherit logFormat;
        serverAliases = [ "themacons.net" "whelchel.org" ];
        extraConfig = ''
          import standard_headers
          redir https://www.{host}{path}
        '';
      };
      "www.kj4jzy.org" = {
        inherit logFormat;
        serverAliases = [ "www.themacons.net" ];
        extraConfig = ''
          import standard_headers
          root * /srv/{host}
          try_files {path} {path}.html
          file_server
        '';
      };
      "www.whelchel.org" = {
        inherit logFormat;
        extraConfig = ''
          import standard_headers
          root * /srv/{host}
          php_fastcgi unix/${config.services.phpfpm.pools.whelchel.socket}
          try_files {path} {path}.html
          file_server {
            index index.html default.htm
          }

          redir /facebook https://www.facebook.com/pages/Whelchel-Family/102868086434186 301
          @oldbook { path_regexp oldbook ^/book/(.*)$ }
          redir @oldbook /history/book/{http.regexp.oldbook.1}

          @private {
            path /history/book/*
            path /history/oral/claire_jameson_2019-12-21*
            path /history/reunion-2020/*
            path /history/scrapbook61-73/*
            path /history/scrapbook69-87/*
            path /history/scrapbook88-03/*
            path /minutes/*
            path /tree/*
          }
          basicauth @private {
            JD JDJhJDEwJHhtNVFGbU1TQk1KUC9lTWYwa0QyM08uMy41T08vOEVRMmg2YTRoVmVROHNoanhDWnpEMmN5
          }
        '';
      };
    };
  };

  users.users.php = {
    isSystemUser = true;
    group = "php";
  };
  users.groups.php = { };
  services.phpfpm.pools.whelchel = {
    user = "php";
    group = "php";
    settings = {
      "pm" = "ondemand";
      "pm.max_children" = 4;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
