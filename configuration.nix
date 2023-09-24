# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tuxie";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-text-editor
    gnome-tour
    gnome.cheese
    gnome.epiphany
    gnome.gnome-characters
    gnome.gnome-music
  ];

  # Keyboard layout
  console.keyMap = "uk";
  services.xserver = {
    layout = "us";
    xkbVariant = "dvorak-alt-intl";
    xkbOptions = "ctrl:nocaps";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

    services.xcape = {
      enable = true;
      mapExpression = {
        Shift_L = "Escape";
        Control_L = "Escape";
      };
    };

    programs = {
      fish = {
        enable = true;
        interactiveShellInit = "fish_vi_key_bindings";
        shellAbbrs = {
          g = "git";
          m = "make";
          n = "nvim";
          nr = "sudo cp ~/git/nix/configuration.nix /etc/nixos/configuration.nix && sudo nixos-rebuild switch";
          ta = "tmux attach -t";
          tn = "tmux new -s";
        };
      };
      git = {
        enable = true;
        userName = "Khoi Nguyen";
        userEmail = "khoi@nguyen.me.uk";
      };
      home-manager = {
        enable = true;
      };
      neovim = {
        enable = true;
        extraConfig = ''
          colorscheme gruvbox-material
          let maplocalleader=","

          noremap <localleader>g <CMD>Git<CR>
          noremap <silent> <C-S> :update<CR>:w<CR>
          inoremap <silent> <C-S> <C-O>:update<CR><C-O>:w<CR>

          set expandtab
          set shiftwidth=2
          set softtabstop=2
          set tabstop=2
          set number
        '';
        plugins = with pkgs.vimPlugins; [
          emmet-vim
          fugitive
          gruvbox-material

          # Auto-completion
          nvim-cmp
          cmp-buffer
          cmp-path
          cmp-nvim-lsp
          cmp-nvim-lua

          {
            plugin = pkgs.vimPlugins.gitsigns-nvim;
            type = "lua";
            config = ''
              require('gitsigns').setup();
            '';
          }
          {
            plugin = pkgs.vimPlugins.lsp-zero-nvim;
            type = "lua";
            config = ''
              local lsp = require('lsp-zero').preset({
                name = 'minimal',
                set_lsp_keymaps = true,
                manage_nvim_cmp = true,
                suggest_lsp_servers = false,
              })
              lsp.setup()
            '';
          }
          {
            plugin = pkgs.vimPlugins.nvim-lspconfig;
            type = "lua";
            config = ''
              require'lspconfig'.nixd.setup{}
              require'lspconfig'.pyright.setup{}
              require'lspconfig'.tsserver.setup{}
              vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
              vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
              vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            '';
          }
          {
            plugin = pkgs.vimPlugins.nvim-tree-lua;
            type = "lua";
            config = ''
              require("nvim-tree").setup()
              local api = require "nvim-tree.api"
              vim.keymap.set('n', '<localleader>t', api.tree.toggle, {})
            '';
          }
          {
            plugin = pkgs.vimPlugins.telescope-nvim;
            type = "lua";
            config = ''
              local builtin = require('telescope.builtin')
              vim.keymap.set('n', '<localleader>ff', builtin.find_files, {})
              vim.keymap.set('n', '<localleader>fg', builtin.live_grep, {})
              vim.keymap.set('n', '<localleader>fb', builtin.buffers, {})
              vim.keymap.set('n', '<localleader>fh', builtin.help_tags, {})
            '';
          }
        ];
        extraPackages = with pkgs; [
          nixd
          nodePackages.typescript-language-server
          pyright
        ];
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
  };

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alacritty
    chromium
    gnome-network-displays
    home-manager
    nodejs_20
    mosh
    pandoc
    python3
    ripgrep
    spotify
    teams
    tmux
    vscode
  ];

  programs = {
    fish = {
      enable = true;
    };
    neovim = {
      enable = true;
    };
  };

  system.stateVersion = "23.05";
}
