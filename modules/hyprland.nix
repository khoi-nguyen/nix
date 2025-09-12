{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  home-manager.users.khoi = {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      settings = {
        "$mod" = "SUPER";
        exec-once = "waybar";
        input = {
          kb_layout = "us";
          kb_variant = "dvorak-alt-intl";
        };
        bind = [
          "$mod, Return, exec, kitty"
          "$mod, B, exec, google-chrome-stable"
          "$mod, D, killactive"
          "$mod SHIFT, Q, exit"
          "$mod, F, fullscreen"
          "$mod, R, exec, wofi --show drun"
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, j, movewindow, d"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, l, movewindow, r"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        ));
        monitor = "eDP-1, preferred, 0x0, 1";
        general = {
          gaps_out = 5;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
        };
        decoration = {
          rounding = 10;
        };
        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = true;
        };
      };
    };
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
