{ pkgs, ... }:

{
  # programs.neovim lets Stylix configure the colorscheme automatically.
  programs.neovim = {
    enable       = true;
    viAlias      = true;
    vimAlias     = true;

    extraPackages = with pkgs; [
      # LSP servers available on PATH inside neovim
      lua-language-server
      nil          # Nix LSP
      pyright      # Python LSP
      # rust-analyzer comes from the rust toolchain in packages.nix
    ];

    plugins = with pkgs.vimPlugins; [
      # File tree
      nvim-tree-lua
      nvim-web-devicons

      # Status line
      lualine-nvim

      # Fuzzy finder
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim

      # LSP
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # Treesitter syntax highlighting
      (nvim-treesitter.withPlugins (p: with p; [
        tree-sitter-nix
        tree-sitter-rust
        tree-sitter-python
        tree-sitter-lua
        tree-sitter-fish
        tree-sitter-toml
        tree-sitter-json
        tree-sitter-yaml
        tree-sitter-bash
        tree-sitter-markdown
      ]))

      # Editing quality-of-life
      nvim-autopairs
      comment-nvim
      gitsigns-nvim
      which-key-nvim
    ];

    extraLuaConfig = ''
      -- Basic options
      vim.opt.number         = true
      vim.opt.relativenumber = true
      vim.opt.tabstop        = 2
      vim.opt.shiftwidth     = 2
      vim.opt.expandtab      = true
      vim.opt.smartindent    = true
      vim.opt.wrap           = false
      vim.opt.scrolloff      = 8
      vim.opt.signcolumn     = "yes"
      vim.opt.updatetime     = 250
      vim.opt.termguicolors  = true
      vim.opt.undofile       = true
      vim.opt.ignorecase     = true
      vim.opt.smartcase      = true

      -- Leader key
      vim.g.mapleader      = " "
      vim.g.maplocalleader = " "

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<leader>e",  "<cmd>NvimTreeToggle<cr>",        { desc = "File tree" })
      map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",   { desc = "Live grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Buffers" })
      map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Help" })
      map("n", "<leader>gg", "<cmd>Telescope git_status<cr>",  { desc = "Git status" })
      map("n", "<C-h>",      "<C-w>h",                         { desc = "Move left" })
      map("n", "<C-l>",      "<C-w>l",                         { desc = "Move right" })
      map("n", "<C-j>",      "<C-w>j",                         { desc = "Move down" })
      map("n", "<C-k>",      "<C-w>k",                         { desc = "Move up" })
      map("n", "<leader>w",  "<cmd>w<cr>",                     { desc = "Save" })
      map("n", "<leader>q",  "<cmd>q<cr>",                     { desc = "Quit" })
      map("n", "]d",         vim.diagnostic.goto_next,         { desc = "Next diagnostic" })
      map("n", "[d",         vim.diagnostic.goto_prev,         { desc = "Prev diagnostic" })
      map("n", "<leader>ca", vim.lsp.buf.code_action,          { desc = "Code action" })
      map("n", "gd",         vim.lsp.buf.definition,           { desc = "Go to definition" })
      map("n", "K",          vim.lsp.buf.hover,                { desc = "Hover docs" })
      map("n", "<leader>rn", vim.lsp.buf.rename,               { desc = "Rename" })

      -- Colorscheme is set by Stylix — do not set it manually here.

      -- Plugins
      require("nvim-tree").setup {}
      require("lualine").setup {}
      require("nvim-autopairs").setup {}
      require("comment").setup {}
      require("gitsigns").setup {}
      require("which-key").setup {}
      require("telescope").setup {
        extensions = { fzf = {} }
      }
      require("telescope").load_extension("fzf")

      -- Treesitter
      require("nvim-treesitter.configs").setup {
        highlight    = { enable = true },
        indent       = { enable = true },
      }

      -- Completion
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm { select = true },
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "luasnip" } },
          { { name = "buffer" }, { name = "path" } }
        ),
      }

      -- LSP
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lsp = require("lspconfig")
      lsp.lua_ls.setup   { capabilities = capabilities }
      lsp.nil_ls.setup   { capabilities = capabilities }
      lsp.pyright.setup  { capabilities = capabilities }
      lsp.rust_analyzer.setup { capabilities = capabilities }
    '';
  };
}
