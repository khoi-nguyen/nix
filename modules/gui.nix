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

  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.sane = {
    enable = true;
    brscan4.enable = true;
    brscan5.enable = true;
    extraBackends = [
      pkgs.sane-airscan
      pkgs.sane-backends
    ];
  };

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
    wireplumber.enable = true;
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
      services.udiskie.enable = true;
    };

  environment.systemPackages = with pkgs; [
    acpilight
    alsa-utils
    autorandr
    feh
    firefox
    google-chrome
    inotify-tools
    killall
    kitty
    libnotify
    libreoffice
    lxrandr
    maim
    mpv
    networkmanagerapplet
    pavucontrol
    peek
    (python3.withPackages pythonEnv)
    poppler_utils
    rofi
    simple-scan
    spotify
    texlive.combined.scheme-full
    transmission_4-qt
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
