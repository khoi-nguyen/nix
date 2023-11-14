{
  imports = [
    ./modules/common.nix
    ./modules/email.nix
    ./modules/gui.nix
  ];

  networking.hostName = "tuxie";
}
