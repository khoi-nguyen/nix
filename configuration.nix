# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

let
  pythonEnv = ps: with ps; [
    matplotlib
    numpy
    sympy
  ];
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./neovim.nix
      ./keyboard.nix
      ./i3.nix
      <home-manager/nixos>
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tuxie";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.groups.video = {};
  users.users.khoi = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.fish;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.khoi = { pkgs, ...}: {
    home.username = "khoi";
    home.homeDirectory = "/home/khoi";
    home.stateVersion = "23.05";

    programs = {
      fish = {
        enable = true;
        interactiveShellInit = ''
          fish_vi_key_bindings
          set fish_greeting
        '';
        plugins = [
          { name = "pure"; src = pkgs.fishPlugins.pure.src; }
        ];
        shellAbbrs = {
          g = "git";
          m = "make";
          n = "nvim";
          nr = "sudo cp ~/git/nix/* /etc/nixos/ && sudo nixos-rebuild switch";
          ta = "tmux attach -t";
          tn = "tmux new -s";
        };
      };
      git = {
        enable = true;
        userName = "Khoi Nguyen";
        userEmail = "khoi@nguyen.me.uk";
      };
      kitty = {
        enable = true;
        settings = {
          background_opacity = "0.9";
          confirm_os_window_close = 0;
          font = "Inconsolata";
        };
        keybindings = {
          "ctrl+equal" = "increase_font_size";
          "ctrl+minus" = "decrease_font_size";
        };
        theme = "Nord";
      };
      home-manager.enable = true;
      rofi = {
        enable = true;
        theme = ./rofi.asi;
      };
      tmux = {
        enable = true;
        extraConfig = ''
          unbind C-b
          bind \` send-prefix
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R
          bind s split-window
          bind v split-window -h
          bind x kill-pane

          set -g base-index 1
          set -g mouse on
          set -g pane-base-index 1
          set -g prefix \`
        '';
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

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    (python3.withPackages pythonEnv)
    acpilight
    arandr
    autorandr
    google-chrome
    home-manager
    killall
    kitty
    libnotify
    maim
    mosh
    nodejs_20
    pandoc
    poppler_utils
    qutebrowser
    ripgrep
    rofi
    spotify
    teams-for-linux
    tmux
    typst
    vifm
    vscode
    xclip
    xournalpp
    zathura
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  programs.fish.enable = true;
  programs.light.enable = true;
  programs.xss-lock.enable = true;

  system.stateVersion = "23.05";
}
