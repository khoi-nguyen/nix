{
  imports = [
    ./common.nix
    ./email.nix
    ./gui.nix
  ];

  networking.hostName = "tuxie";
}
