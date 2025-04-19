{ pkgs, lib, ... }:
let
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    }
  );
in
{
  imports = [
    nixvim.nixosModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.vscode.enable = true;
    globals.mapleader = ",";

    keymaps = [
      {
        key = "<leader>g";
        action = "<cmd>LazyGit<CR>";
      }
      {
        key = "<leader>w";
        action = "<cmd>w<CR>";
      }
      {
        key = "<leader>t";
        action = "<cmd>NvimTreeToggle<CR>";
      }
    ];

    opts = {
      # Indent
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      # Numbering
      number = true;
      relativenumber = true;
    };

    plugins = {
      autoclose.enable = true;
      blink-cmp = {
        enable = true;
        settings.keymap.preset = "super-tab";
      };
      conform-nvim = {
        enable = true;
        settings = {
          formatters = {
            nixfmt.command = lib.getExe pkgs.nixfmt-rfc-style;
          };
          formatters_by_ft = {
            javascript = [ "prettier" ];
            nix = [ "nixfmt" ];
            typescript = [ "prettier" ];
            typescriptreact = [ "prettier" ];
          };
          format_on_save = {
            lspFallback = true;
            timeoutMs = 1000;
          };
        };
      };
      fugitive.enable = true;
      gitsigns.enable = true;
      lazygit.enable = true;
      lint.enable = true;
      lsp = {
        enable = true;
        keymaps = {
          lspBuf = {
            gi.action = "implementation";
            K.action = "hover";
          };
          diagnostic = {
            gl.action = "open_float";
          };
        };
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          tailwindcss.enable = true;
          ts_ls.enable = true;
          yamlls.enable = true;
        };
      };
      lsp-format = {
        enable = true;
      };
      lualine.enable = true;
      numbertoggle.enable = true;
      nvim-tree.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
        };
      };
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      vim-surround.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
    };
  };
}
