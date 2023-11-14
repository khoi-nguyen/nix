{
  imports = [
    ./modules/common.nix
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
    };
  };

  services.openssh.enable = true;
}
