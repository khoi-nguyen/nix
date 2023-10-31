{ pkgs, ... }:

let
  mod = "Mod4";
in
{
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
      ];
    };
  };

  home-manager.users.khoi.xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      terminal = pkgs.kitty;
      keybindings = {
        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${mod}+a" = "focus parent";
        "${mod}+b" = "exec --no-startup-id google-chrome-stable";
        "${mod}+Shift+b" = "exec --no-startup-id qutebrowser";
        "${mod}+d" = "kill";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+m" = "move workspace to output right";
        "${mod}+Shift+m" = "exec autorandr --change";
        "${mod}+n" = "exec i3-input -F 'rename workspace to \"%s\"' -P 'New name for this workspace: '";
        "${mod}+p" = "exec --no-startup-id xopen";
        "${mod}+r" = "exec --no-startup-id rofi -show drun";
        "Mod1+r" = "mode resize";
        "${mod}+Shift+r" = "reload";
        "${mod}+t" = "exec --no-startup-id select_tmux_session";
        "${mod}+x" = "exec --no-startup-id loginctl lock-session";
        "Print" = "exec --no-startup-id maim --select | xclip -selection clipboard -t image/png";

        # Scratchpad
        "${mod}+minus" = "scratchpad show";
        "${mod}+Shift+minus" = "move scratchpad";

        # Layouts
        "${mod}+apostrophe" = "layout stacking";
        "${mod}+comma" = "layout tabbed";
        "${mod}+period" = "layout toggle split";

        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";
        "${mod}+bracketright" = "workspace next";
        "${mod}+bracketleft" = "workspace prev";

        # H, J, K, L
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # Split
        "${mod}+w" = "split h";
        "${mod}+v" = "split v";

        "XF86AudioRaiseVolume" = "exec amixer -D pipewire sset Master 5%+";
        "XF86AudioLowerVolume" = "exec amixer -D pipewire sset Master 5%-";
        "XF86AudioMute" = "exec amixer -D pipewire set Master 1+ toggle";
        "XF86MonBrightnessUp" = "exec light -A 5";
        "XF86MonBrightnessDown" = "exec light -U 5";
      };
      modes = {
        resize = {
          "h" = "resize shrink width 10 px or 10 ppt";
          "j" = "resize grow height 10 px or 10 ppt";
          "k" = "resize shrink height 10 px or 10 ppt";
          "l" = "resize grow width 10 px or 10 ppt";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
    };
    extraConfig = ''
      exec --no-startup-id picom -b
      exec --no-startup-id xss-lock --transfer-sleep-lock --i3lock --nofork
      gaps inner 5
      gaps outer 5
      smart_gaps inverse_outer
    '';
  };
}
