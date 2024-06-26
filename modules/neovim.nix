{ pkgs, lib, ... }:

let
  fromGithub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
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
  home-manager.users.khoi = {

    home.file."injections.scm" = {
      source = ./nvim/treesitter.scm;
      target = ".config/nvim/after/queries/ecma/injections.scm";
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
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
        set termguicolors
      '';
      plugins = with pkgs.vimPlugins; [
        catppuccin-nvim
        emmet-vim
        fugitive
        gruvbox-material
        nvim-web-devicons
        typst-vim
        vim-pandoc-syntax
        vim-pandoc
        {
          plugin = (fromGithub "17179d7f2a73172af5f9a8d65b01a3acf12ddd50" "master" "jxnblk/vim-mdx-js");
        }

        {
          plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
          type = "lua";
          config = ''
            require'nvim-treesitter.configs'.setup {
              highlight = {
                enable = true,
              },
            }
          '';
        }
        {
          plugin = pkgs.vimPlugins.lualine-nvim;
          type = "lua";
          config = ''
            require('lualine').setup({
              options = { theme = 'gruvbox' }
            })
          '';
        }

        # Snippets
        {
          plugin = pkgs.vimPlugins.luasnip;
          type = "lua";
          config = ''
            require("luasnip.loaders.from_snipmate").lazy_load({paths = "${./snippets}/"})
          '';
        }
        friendly-snippets
        {
          plugin = pkgs.vimPlugins.friendly-snippets;
          type = "lua";
          config = ''
            require("luasnip.loaders.from_vscode").lazy_load()
          '';
        }

        # Auto-completion
        nvim-cmp
        cmp-buffer
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-path
        cmp_luasnip

        {
          plugin = pkgs.vimPlugins.iron-nvim;
          type = "lua";
          config = ''
            require("iron.core").setup({
              config = {
                scratch_repl = true,
                repl_open_cmd = require("iron.view").split("40%"),
              },
              keymaps = {
                send_motion = "<localleader>sc",
                visual_send = "<localleader>sc",
                send_file = "<localleader>sf",
                exit = "<localleader>sq",
                clear = "<localleader>cl",
              },
            })
          '';
        }
        {
          plugin = pkgs.vimPlugins.nvim-surround;
          type = "lua";
          config = "require('nvim-surround').setup({})";
        }
        {
          plugin = pkgs.vimPlugins.neoformat;
          config = "autocmd BufWritePre *.ts,*.tsx,*.json,*.scss,*.py,*.astro Neoformat";
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

            local cmp = require('cmp')
            local cmp_format = require('lsp-zero').cmp_format()
            local cmp_action = require('lsp-zero').cmp_action()

            cmp.setup({
              preselect = 'item',
              completion = {
                completeopt = 'menu,menuone,noinsert'
              },
              sources = {
                {name = 'luasnip'},
                {name = 'nvim_lsp'},
                {name = 'path'},
                {name = 'buffer'},
              },
              mapping = cmp.mapping.preset.insert({
                ['<C-L>'] = cmp_action.luasnip_supertab(),
                ['<C-H>'] = cmp_action.luasnip_shift_supertab(),
                ['<CR>'] = cmp.mapping.confirm({select = false}),
              }),
              formatting = cmp_format,
            })
          '';
        }
        {
          plugin = pkgs.vimPlugins.nvim-lspconfig;
          type = "lua";
          config = ''
            require'lspconfig'.nil_ls.setup{}
            require'lspconfig'.pyright.setup{}
            require'lspconfig'.astro.setup{}
            require'lspconfig'.svelte.setup{}
            require'lspconfig'.tailwindcss.setup{}
            require("lspconfig").tsserver.setup{
              settings = {
                implicitProjectConfiguration = { 
                  checkJs = true
                },
              }
            }
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
        black
        nil
        nodePackages.typescript-language-server
        nodePackages.prettier
        nodePackages."@astrojs/language-server"
        nodePackages.svelte-language-server
        tailwindcss-language-server
        pyright
      ];
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
