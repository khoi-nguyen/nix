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

  users.users.khoi = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
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
        interactiveShellInit = "fish_vi_key_bindings";
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
          confirm_os_window_close = 0;
          font = "Inconsolata";
        };
        theme = "Gruvbox Dark";
      };
      home-manager.enable = true;
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

    services.dunst.enable = true;
  };

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    (python3.withPackages pythonEnv)
    acpilight
    arandr
    autorandr
    gnome-network-displays
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
    spotify
    teams
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

  system.stateVersion = "23.05";
}
