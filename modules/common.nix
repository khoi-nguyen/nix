# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
    <home-manager/nixos>
    ./nvim.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_GB.UTF-8";

  users.groups.video = { };
  users.users.khoi = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "scanner"
      "video"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCWJ2go62qezCgO9nXn2urHrfDgusTE65murDBUdc9MYK7ERYSH4HFd34uObUk6n3Dc+E7LNRYR4jcX3Tb3eXATsoc50rjogJ1mfdMgcI6rtEjD2ystQNkyA0iRy+yX5v3VbRM0dNolOI19lk9w59BYp6G6wEjXQZDrubGMO5U/xhCazNvLGTQV1nUw1vIke4iTKKXha3siTbf/Rsoks/6wZK1Z7wAVNpoFbSIskN9TSGdgMRq7X0yDAQNT8ZDSRMtQmAMUq3eP5vy2Spwr1N9S6f6+OQkSucGvwEHQ5NdmwvAvYx1cgBnFaYpVYlsTaOOk9Me/m/r0+olOaCnMMvN7"
    ];
    shell = pkgs.fish;
  };

  fonts.packages = with pkgs; [
    font-awesome
    material-design-icons
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.khoi =
    { pkgs, ... }:
    {
      home.username = "khoi";
      home.homeDirectory = "/home/khoi";
      home.stateVersion = "23.05";
      home.packages = [
        (pkgs.buildEnv {
          name = "my-scripts";
          paths = [ ../scripts ];
        })
      ];
      home.sessionVariables = {
        EDITOR = "nvim";
      };

      programs = {
        fish = {
          enable = true;
          interactiveShellInit = ''
            fish_vi_key_bindings
            set fish_greeting
          '';
          plugins = [
            {
              name = "pure";
              src = pkgs.fishPlugins.pure.src;
            }
          ];
          shellAbbrs = {
            dc = "docker compose";
            g = "git";
            m = "neomutt";
            n = "lvim";
            nc = "nix-collect-garbage -d && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
            nr = "sudo cp -r ~/git/nix/* /etc/nixos/ && sudo nixos-rebuild switch";
            p = "wl-paste -t image/png >";
            ta = "tmux attach -t";
            tn = "tmux new -s";
          };
        };
        git = {
          enable = true;
          userName = "Khoi Nguyen";
          userEmail = "khoi@nguyen.me.uk";
          extraConfig = {
            core.editor = "nvim";
            pull.rebase = false;
          };
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
    ferdium
    fd
    gnumake42
    hey
    home-manager
    httpie
    lazygit
    lunarvim
    mosh
    nodejs_20
    pandoc
    poetry
    python3
    ripgrep
    tmux
    typst
    unzip
    vifm
    w3m
  ];

  programs.direnv.enable = true;
  programs.fish.enable = true;

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "bip" = "192.168.245.1/24";
      "default-address-pools" = [
        {
          "base" = "192.168.240.0/20";
          "size" = 24;
        }
      ];
    };
  };

  system.stateVersion = "23.05";
}
