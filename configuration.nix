# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

let
  pythonEnv = ps: with ps; [
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
  imports =
    [
      ./tuxie.nix
      ./hardware-configuration.nix
      ./neovim.nix
      <home-manager/nixos>
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_GB.UTF-8";

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
    home.packages = [
      (pkgs.buildEnv {
        name = "my-scripts";
        paths = [ ./scripts ];
      })
    ];

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
          m = "neomutt";
          n = "nvim";
          nc = "nix-collect-garbage -d && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
          nr = "sudo cp -r ~/git/nix/* /etc/nixos/ && sudo nixos-rebuild switch";
          ta = "tmux attach -t";
          tn = "tmux new -s";
        };
      };
      git = {
        enable = true;
        userName = "Khoi Nguyen";
        userEmail = "khoi@nguyen.me.uk";
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
        plugins = with pkgs.tmuxPlugins; [
          power-theme
          resurrect
          continuum
        ];
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    (python3.withPackages pythonEnv)
    fd
    home-manager
    julia
    mosh
    nodejs_20
    pandoc
    ripgrep
    tmux
    typst
    unzip
    w3m
    xclip
    yazi
  ];

  programs.fish.enable = true;

  system.stateVersion = "23.05";
}
