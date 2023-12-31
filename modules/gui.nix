{ pkgs, ... }:

{
  imports =
    [
      ./keyboard.nix
      ./i3.nix
    ];

  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  home-manager.users.khoi = { pkgs, ... }: {
    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = ["org.pwmt.zathura.desktop"];
        "image/jpeg" = ["feh.desktop"];
      };
      defaultApplications = {
        "application/pdf" = ["org.pwmt.zathura.desktop"];
        "image/jpeg" = ["feh.desktop"];
        "x-scheme-handler/msteams" = ["teams-for-linux.desktop"];
        "x-scheme-handler/webcal" = ["google-chrome.desktop"];
      };
    };

    programs = {
      kitty = {
        enable = true;
        settings = {
          background_opacity = "0.95";
          confirm_os_window_close = 0;
          font_family = "Inconsolata Nerd Font Mono";
          font_size = "12.0";
        };
        keybindings = {
          "ctrl+equal" = "increase_font_size";
          "ctrl+minus" = "decrease_font_size";
        };
        theme = "Nord";
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
    services.picom.enable = true;
  };

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  environment.systemPackages = with pkgs; [
    acpilight
    arandr
    autorandr
    feh
    google-chrome
    inotify-tools
    killall
    kitty
    libnotify
    libreoffice
    maim
    networkmanagerapplet
    poppler_utils
    qutebrowser
    rofi
    spotify
    teams-for-linux
    vscode
    xournalpp
    zathura
    zoom-us
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

  virtualisation.docker.enable = true;
}
