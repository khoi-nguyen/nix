{ pkgs, ... }:

{
  imports = [
    ./modules/common.nix
  ];

  environment.systemPackages = with pkgs; [
    nodePackages.pm2
  ];

  networking = {
    hostName = "ngy";
    interfaces.eth0.ipv4.addresses = [
      {
        address = "172.17.0.253";
        prefixLength = 24;
      }
    ];
    defaultGateway = "172.17.0.13";
    nameservers = ["172.17.0.200" "172.17.0.99"];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 8022 ];
      allowedUDPPortRanges = [
        { from = 60000; to = 61000; }
      ];
    };
  };

  programs.mosh.enable = true;

  services = {
    openssh.enable = true;
    nginx = {
      enable = true;
      clientMaxBodySize = "100M";
      recommendedGzipSettings = true;
      virtualHosts."ngy.ecam.be" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          extraConfig =  ''
            X-Frame-Options: Allow-From *.zebrix.net;
            Content-Security-Policy: frame-ancestors 'self' *.zebrix.net;
          '';
        };
        forceSSL = true;
        enableACME = true;
      };
      virtualHosts."nguyen.me.uk" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          extraConfig =  ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
          '';
        };
        forceSSL = true;
        enableACME = true;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "khoi@nguyen.me.uk";
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
