-- #######################################################################################
-- KICKSTART-BASED NEOVIM CONFIG
-- Plugins: LSP (PHP/Laravel, JS/TS, HTML, CSS, TailwindCSS), Autocomplete,
--          Treesitter, Telescope, Neo-tree, Lualine, Git, Formatting, and more.
-- #######################################################################################

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── Options ─────────────────────────────────────────────────────────────────────────────
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.mouse          = "a"
vim.opt.showmode       = false
vim.opt.clipboard      = "unnamedplus"
vim.opt.breakindent    = true
vim.opt.undofile       = true
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.signcolumn     = "yes"
vim.opt.updatetime     = 250
vim.opt.timeoutlen     = 300
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.list           = true
vim.opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand     = "split"
vim.opt.cursorline     = true
vim.opt.scrolloff      = 10
vim.opt.hlsearch       = true
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true
vim.opt.termguicolors  = true
vim.opt.wrap           = false
vim.opt.pumheight      = 10

-- ── Keymaps ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<Esc>",              "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q",          vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix" })
vim.keymap.set("t", "<Esc><Esc>",         "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>",             "<C-w><C-h>", { desc = "Move focus left" })
vim.keymap.set("n", "<C-l>",             "<C-w><C-l>", { desc = "Move focus right" })
vim.keymap.set("n", "<C-j>",             "<C-w><C-j>", { desc = "Move focus down" })
vim.keymap.set("n", "<C-k>",             "<C-w><C-k>", { desc = "Move focus up" })
vim.keymap.set("n", "<leader>w",         "<cmd>w<CR>",  { desc = "Save file" })
vim.keymap.set("n", "<leader>bd",        "<cmd>bdelete<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>e",         "<cmd>Neotree toggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("v", "<",                 "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">",                 ">gv", { desc = "Indent right" })
vim.keymap.set("n", "<leader>/",         "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<leader>/",         "gc",  { remap = true, desc = "Toggle comment" })

-- ── Bootstrap lazy.nvim ─────────────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ─────────────────────────────────────────────────────────────────────────────
require("lazy").setup({

  -- ── Colorscheme ─────────────────────────────────────────────────────────────────
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style        = "night",
      transparent  = true,
      terminal_colors = true,
      styles = {
        comments   = { italic = true },
        keywords   = { italic = true },
        sidebars   = "dark",
        floats     = "dark",
      },
    },
    init = function()
      vim.cmd.colorscheme("tokyonight-night")
      vim.cmd.hi("Comment gui=none")
    end,
  },

  -- ── UI Improvements ─────────────────────────────────────────────────────────────
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                = "tokyonight",
        globalstatus         = true,
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode               = "buffers",
        separator_style    = "slant",
        show_buffer_close_icons = true,
        diagnostics        = "nvim_lsp",
      },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = { override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      }},
      presets = {
        bottom_search        = true,
        command_palette      = true,
        long_message_to_split = true,
        inc_rename           = false,
        lsp_doc_border       = true,
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
      timeout            = 3000,
      render             = "wrapped-compact",
    },
  },

  -- ── File Explorer (Neo-tree) ─────────────────────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch  = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      window = { width = 30 },
      filesystem = {
        filtered_items = {
          visible         = true,
          hide_dotfiles   = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
      },
    },
  },

  -- ── Telescope (Fuzzy Finder) ─────────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    event        = "VimEnter",
    branch       = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local builtin   = require("telescope.builtin")
      telescope.setup({
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "Telescope: " .. desc })
      end
      map("<leader>sh", builtin.help_tags,    "Search Help")
      map("<leader>sk", builtin.keymaps,      "Search Keymaps")
      map("<leader>sf", builtin.find_files,   "Search Files")
      map("<leader>ss", builtin.builtin,      "Search Select Telescope")
      map("<leader>sw", builtin.grep_string,  "Search current Word")
      map("<leader>sg", builtin.live_grep,    "Search by Grep")
      map("<leader>sd", builtin.diagnostics,  "Search Diagnostics")
      map("<leader>sr", builtin.resume,       "Search Resume")
      map("<leader>s.", builtin.oldfiles,     "Search Recent Files")
      map("<leader><leader>", builtin.buffers, "Find existing buffers")
      map("<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, "Search Neovim files")
    end,
  },

  -- ── LSP Config ──────────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          map("gd",         require("telescope.builtin").lsp_definitions,      "Goto Definition")
          map("gr",         require("telescope.builtin").lsp_references,        "Goto References")
          map("gI",         require("telescope.builtin").lsp_implementations,   "Goto Implementation")
          map("<leader>D",  require("telescope.builtin").lsp_type_definitions,  "Type Definition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols,  "Document Symbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
          map("<leader>rn", vim.lsp.buf.rename,                                 "Rename")
          map("<leader>ca", vim.lsp.buf.code_action,                            "Code Action")
          map("gD",         vim.lsp.buf.declaration,                            "Goto Declaration")
          map("K",          vim.lsp.buf.hover,                                  "Hover Documentation")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local grp = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf, group = grp, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf, group = grp, callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(e2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = e2.buf })
              end,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- Servers to install & configure
      local servers = {
        -- Web
        html               = {},
        cssls              = {},
        tailwindcss        = {
          filetypes = { "html", "css", "javascript", "typescript", "blade", "php", "vue" },
        },
        emmet_ls           = {
          filetypes = { "html", "css", "blade", "php", "javascript", "typescript", "vue" },
        },
        -- JavaScript / TypeScript
        ts_ls              = {
          settings = {
            typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
            javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
          },
        },
        eslint             = {},
        -- PHP / Laravel
        intelephense       = {
          settings = {
            intelephense = {
              stubs = {
                "bcmath","bz2","calendar","Core","curl","date","dba","dom","enchant",
                "fileinfo","filter","ftp","gd","gettext","hash","iconv","imap","intl",
                "json","ldap","libxml","mbstring","mcrypt","mysql","mysqli","password",
                "pcntl","pcre","PDO","pdo_mysql","Phar","posix","pspell","readline",
                "recode","Reflection","regex","session","shmop","SimpleXML","snmp",
                "soap","sockets","sodium","SPL","standard","superglobals","sysvmsg",
                "sysvsem","sysvshm","tidy","tokenizer","xml","xdebug","xmlreader",
                "xmlrpc","xmlwriter","xsl","Zend OPcache","zip","zlib","Laravel",
              },
              environment = { phpVersion = "8.1" },
              files = { maxSize = 5000000 },
            },
          },
        },
        -- Lua
        lua_ls             = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim" } },
            },
          },
        },
      }

      require("mason").setup()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier", "stylua", "isort", "black",
          "phpcs", "php-cs-fixer",
          "eslint_d",
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },

  -- ── Autocompletion ──────────────────────────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event        = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "path",     priority = 500 },
          { name = "buffer",   priority = 250 },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local kind_icons = {
              Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
              Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
              Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
              Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
              File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
              Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
              TypeParameter = "",
            }
            item.kind = string.format("%s %s", kind_icons[item.kind] or "", item.kind)
            item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
            })[entry.source.name]
            return item
          end,
        },
      })
    end,
  },

  -- ── Formatting ──────────────────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    keys  = {
      {
        "<leader>f",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode  = { "n", "v" },
        desc  = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save  = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms   = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua        = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        css        = { "prettier" },
        html       = { "prettier" },
        json       = { "prettier" },
        markdown   = { "prettier" },
        php        = { "php_cs_fixer" },
        blade      = { "blade_formatter" },
      },
    },
  },

  -- ── Treesitter ──────────────────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build   = ":TSUpdate",
    main    = "nvim-treesitter.configs",
    opts    = {
      ensure_installed = {
        "bash", "c", "html", "css", "javascript", "typescript",
        "json", "lua", "luadoc", "markdown", "markdown_inline",
        "php", "phpdoc", "regex", "toml", "tsx", "vim", "vimdoc",
        "yaml", "vue", "sql",
      },
      auto_install    = true,
      highlight       = { enable = true },
      indent          = { enable = true },
    },
  },

  -- ── Laravel / Blade ─────────────────────────────────────────────────────────────
  {
    "jwalton512/vim-blade",
    ft = { "blade" },
  },

  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
    },
    cmd  = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>",  desc = "Laravel Artisan" },
      { "<leader>lr", ":Laravel routes<cr>",   desc = "Laravel Routes" },
      { "<leader>lm", ":Laravel related<cr>",  desc = "Laravel Related files" },
    },
    event = { "VeryLazy" },
    config = true,
  },

  -- ── Git ─────────────────────────────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "Git: " .. desc })
        end
        map("n", "<leader>gp", gs.preview_hunk,           "Preview Hunk")
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle Blame")
        map("n", "<leader>gd", gs.diffthis,               "Diff This")
        map("n", "]c",         gs.next_hunk,               "Next Hunk")
        map("n", "[c",         gs.prev_hunk,               "Prev Hunk")
        map("n", "<leader>gs", gs.stage_hunk,              "Stage Hunk")
        map("n", "<leader>gr", gs.reset_hunk,              "Reset Hunk")
      end,
    },
  },

  -- ── Utilities ───────────────────────────────────────────────────────────────────
  { "folke/which-key.nvim",    event = "VimEnter",  opts = {} },
  { "tpope/vim-sleuth" },       -- Auto detect tabstop/shiftwidth
  {
    "folke/todo-comments.nvim",
    event        = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = { signs = false },
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup()
      require("mini.pairs").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>",                       desc = "Toggle Trouble" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics" },
    },
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    ft   = { "html", "javascript", "typescript", "jsx", "tsx", "php", "blade", "vue" },
    opts = {},
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufEnter",
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB      = true,
        RRGGBB   = true,
        names    = false,
        css      = true,
        css_fn   = true,
        tailwind = true,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys    = { { "<C-\\>", desc = "Toggle terminal" } },
    opts    = {
      open_mapping     = [[<C-\>]],
      direction        = "float",
      float_opts       = { border = "curved" },
      shell            = "zsh",
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘", config = "🛠", event = "📅", ft = "📂",
      init = "⚙", keys = "🗝", plugin = "🔌", runtime = "💻",
      require = "🌙", source = "📄", start = "🚀", task = "📌",
      lazy = "💤 ",
    },
  },
})
-- vim: ts=2 sts=2 sw=2 et
