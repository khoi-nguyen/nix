{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  home-manager.users.khoi = {
    programs = {
      waybar = {
        enable = true;
        settings = [
          {
            modules-left = [
              "hyprland/workspaces"
            ];
            modules-center = [
              "hyprland/window"
            ];
            modules-right = [
              "pulseaudio"
              "network"
              "cpu"
              "memory"
              "battery"
              "clock"
            ];
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wofi
  ];
}
