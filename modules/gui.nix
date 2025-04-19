{ pkgs, ... }:

let
  pythonEnv =
    ps: with ps; [
      antlr4-python3-runtime
      jupyter
      matplotlib
      notebook
      numpy
      pandas
      panflute
      pip
      scipy
      sympy
    ];
in
{
  imports = [
    ./keyboard.nix
    ./i3.nix
  ];

  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services = {
    xserver = {
      enable = true;
    };
    displayManager = {
      defaultSession = "none+i3";
    };
  };

  home-manager.users.khoi =
    { pkgs, ... }:
    {
      xdg.mimeApps = {
        enable = true;
        associations.added = {
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "image/jpeg" = [ "feh.desktop" ];
        };
        defaultApplications = {
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "image/jpeg" = [ "feh.desktop" ];
          "x-scheme-handler/msteams" = [ "teams-for-linux.desktop" ];
          "x-scheme-handler/webcal" = [ "google-chrome.desktop" ];
        };
      };

      programs = {
        kitty = {
          enable = true;
          settings = {
            confirm_os_window_close = 0;
            font_family = "FiraCode Nerd Font";
            font_size = "12.0";
          };
          keybindings = {
            "ctrl+equal" = "increase_font_size";
            "ctrl+minus" = "decrease_font_size";
          };
          themeFile = "Nord";
        };
        rofi = {
          enable = true;
          theme = ../home/rofi.asi;
        };
      };

      services.redshift = {
        enable = true;
        latitude = 50.8476;
        longitude = 4.3572;
      };
      services.dunst.enable = true;
    };

  environment.systemPackages = with pkgs; [
    acpilight
    alsa-utils
    autorandr
    feh
    google-chrome
    inotify-tools
    killall
    kitty
    libnotify
    libreoffice
    lxde.lxrandr
    maim
    mpv
    networkmanagerapplet
    (python3.withPackages pythonEnv)
    poppler_utils
    qutebrowser
    rofi
    spotify
    texlive.combined.scheme-full
    vscode
    xclip
    xournalpp
    yazi
    zathura
  ];

  programs.light.enable = true;
  programs.xss-lock.enable = true;

  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "powersave";
      turbo = "never";
    };
  };
}
