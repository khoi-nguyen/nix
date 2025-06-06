{
  imports = [
    ./modules/common.nix
    ./modules/gui.nix
  ];

  networking.hostName = "tuxie";

  services.udisks2.enable = true;
}
