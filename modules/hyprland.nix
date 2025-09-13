{ pkgs, ... }:

let
  catppuccinWaybar = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "waybar";
    rev = "main";
    sha256 = "sha256-za0y6hcN2rvN6Xjf31xLRe4PP0YyHu2i454ZPjr+lWA";
  };
in
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
          "$mod, P, exec, xopen"
          "$mod, R, exec, rofi -show drun"
          "$mod, T, exec, select_tmux_session"
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, j, movewindow, d"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, l, movewindow, r"
          "$mod, m, movecurrentworkspacetomonitor, +1"
          "$mod, bracketright, workspace, e+1"
          "$mod, bracketleft, workspace, e-1"
        ]
        ++ (builtins.concatLists (
          builtins.genList (i: [
            "$mod, ${toString i}, workspace, ${toString i}"
            "$mod SHIFT, ${toString i}, movetoworkspace, ${toString i}"
          ]) 10
        ))
        ++ [
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 0, movetoworkspace, 10"
        ];
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
        ];
        monitor = [
          "eDP-1, preferred, 0x0, 1"
          "desc:Samsung Electric Company LU28R55 HNMX300129, 2560x1440, auto-left, 1"
          ", preferred, auto-left, 1"
        ];
        general = {
          gaps_out = 5;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
        };
        animations.enabled = false;
        decoration = {
          rounding = 10;
        };
        device = {
          name = "wacom-cintiq-pro-24-pen";
          output = "HDMI-A-1";
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
              "battery"
              "clock"
            ];
          }
        ];
        style = ''
          @import "${catppuccinWaybar}/themes/mocha.css";
          * {
            font-family: FantasqueSansMono Nerd Font;
            font-size: 11px;
            min-height: 0;
          }

          #waybar {
            background: transparent;
            color: @text;
            margin: 2px 2px;
          }

          #workspaces {
            border-radius: 1rem;
            margin: 5px;
            background-color: @surface0;
            margin-left: 1rem;
          }

          #workspaces button {
            color: @lavender;
            border-radius: 1rem;
            padding: 0.2rem;
          }

          #workspaces button.active {
            color: @sky;
            font-weight: bold;
            border-radius: 1rem;
          }

          #workspaces button:hover {
            color: @sapphire;
            border-radius: 1rem;
          }

          #custom-music,
          #tray,
          #backlight,
          #clock,
          #battery,
          #pulseaudio,
          #custom-lock,
          #custom-power {
            background-color: @surface0;
            padding: 0.5rem 1rem;
            margin: 5px 0;
          }

          #clock {
            color: @blue;
            border-radius: 0px 1rem 1rem 0px;
            margin-right: 1rem;
          }

          #battery {
            color: @green;
          }

          #battery.charging {
            color: @green;
          }

          #battery.warning:not(.charging) {
            color: @red;
          }

          #backlight {
            color: @yellow;
          }

          #backlight, #battery {
              border-radius: 0;
          }

          #pulseaudio {
            color: @maroon;
            border-radius: 1rem 0px 0px 1rem;
            margin-left: 1rem;
          }

          #custom-music {
            color: @mauve;
            border-radius: 1rem;
          }

          #custom-lock {
              border-radius: 1rem 0px 0px 1rem;
              color: @lavender;
          }

          #custom-power {
              margin-right: 1rem;
              border-radius: 0px 1rem 1rem 0px;
              color: @red;
          }

          #tray {
            margin-right: 1rem;
            border-radius: 1rem;
          }
        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    wofi
  ];
}
