{ pkgs, lib, ... }:

let
  fromGithub = rev: ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
in
{
  home-manager.users.khoi.programs.neovim = {
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
      nvim-treesitter.withAllGrammars
      nvim-web-devicons

      # Snippets
      friendly-snippets
      luasnip

      # Auto-completion
      nvim-cmp
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp_luasnip

      {
        plugin = pkgs.vimPlugins.nvim-surround;
        type = "lua";
        config = "require('nvim-surround').setup({})";
      }
      {
        plugin = pkgs.vimPlugins.neoformat;
        config = "autocmd BufWritePre *.ts,*.tsx,*.json,*.scss Neoformat";
      }
      {
        plugin = pkgs.vimPlugins.gitsigns-nvim;
        type = "lua";
        config = "require('gitsigns').setup()";
      }
      {
        plugin = (fromGithub "5dc9d9b67f323c3e73c966aaa70728b7c0c380b3" "v3.x" "VonHeikemen/lsp-zero.nvim");
        type = "lua";
        config = ''
          local lsp_zero = require('lsp-zero')
          lsp_zero.on_attach(function(client, bufnr)
            lsp_zero.default_keymaps({buffer = bufnr})
          end)
        '';
      }
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = ''
          require'lspconfig'.nil_ls.setup{}
          require'lspconfig'.pyright.setup{}
          require'lspconfig'.tsserver.setup{}
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
      nil
      nodePackages.typescript-language-server
      nodePackages.prettier
      pyright
    ];
  };

  programs.neovim.enable = true;
}