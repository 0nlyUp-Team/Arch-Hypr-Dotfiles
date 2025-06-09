-- init.lua
-- Neovim конфигурация с nvim-tree, treesitter, lsp-zero, indent-blankline и подсветкой цветов

-- Базовые настройки
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 120

-- Установка leader key
vim.g.mapleader = " "

-- Установка пакетного менеджера lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Конфигурация плагинов
require("lazy").setup({
  -- Цветовая схема
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true, -- Прозрачный фон
        integrations = {
          nvimtree = true,
        },
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end
  },

  -- nvim-tree (файловый менеджер)
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Отключить netrw для корректной работы nvim-tree
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          root_folder_label = false,
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
        },
        actions = {
          open_file = {
            quit_on_open = false, -- Не закрывать дерево при открытии файла
          },
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query", "javascript", "typescript",
          "python", "html", "css", "json", "yaml", "bash", "rust", "go"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
      })
    end,
  },

  -- LSP Zero
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        local opts = {buffer = bufnr, remap = false}

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end)

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {'lua_ls', 'rust_analyzer', 'pyright', 'tsserver'},
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        }
      })

      local cmp = require('cmp')
      local cmp_select = {behavior = cmp.SelectBehavior.Select}

      cmp.setup({
        sources = {
          {name = 'path'},
          {name = 'nvim_lsp'},
          {name = 'nvim_lua'},
          {name = 'buffer', keyword_length = 3},
          {name = 'luasnip', keyword_length = 2},
        },
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
      })
    end,
  },

  -- Indent Blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
        },
      })
    end,
  },

  -- Подсветка цветов
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup({
        filetypes = {
          '*', -- Подсветка во всех типах файлов
          css = {
            rgb_fn = true,
            hsl_fn = true,
            css = true,
            css_fn = true,
          },
          html = {
            names = true,
            rgb_fn = true,
            hsl_fn = true,
          },
          javascript = {
            rgb_fn = true,
            hsl_fn = true,
          },
          lua = {
            names = false,
          },
        },
        user_default_options = {
          RGB = true,         -- #RGB hex коды
          RRGGBB = true,      -- #RRGGBB hex коды
          names = true,       -- "Name" коды вроде Blue или blue
          RRGGBBAA = true,    -- #RRGGBBAA hex коды
          AARRGGBB = true,    -- 0xAARRGGBB hex коды
          rgb_fn = true,      -- CSS rgb() и rgba() функции
          hsl_fn = true,      -- CSS hsl() и hsla() функции
          css = true,         -- Включить все CSS возможности
          css_fn = true,      -- Включить все CSS функции
          mode = "background", -- Подсвечивать фон
          tailwind = false,   -- Включить tailwind цвета
          sass = { enable = true, parsers = { "css" }, },
          virtualtext = "■",
          always_update = false
        },
        buftypes = {},
      })
    end,
  },

  -- Дополнительно: Telescope для поиска файлов
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<C-j>"] = require("telescope.actions").move_selection_next,
            }
          }
        }
      })
    end,
  },

  -- Статусная строка
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'catppuccin'
        }
      })
    end,
  },
})

-- Горячие клавиши
local keymap = vim.keymap

-- nvim-tree
keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap.set("n", "<leader>ef", ":NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- Colorizer (подсветка цветов)
keymap.set("n", "<leader>ct", ":ColorizerToggle<CR>", { desc = "Toggle colorizer" })
keymap.set("n", "<leader>cr", ":ColorizerReloadAllBuffers<CR>", { desc = "Reload colorizer" })

-- Telescope
keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find files" })
keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live grep" })
keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Find buffers" })
keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Help tags" })

-- Общие горячие клавиши
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Управление окнами
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Управление табами
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-- Перемещение по буферам
keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })

-- Автокоманды
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Включить colorizer при открытии файлов
augroup("ColorizerAutostart", { clear = true })
autocmd({"BufRead", "BufNewFile"}, {
  group = "ColorizerAutostart",
  pattern = {"*.css", "*.html", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.scss", "*.sass", "*.less", "*.lua"},
  callback = function()
    vim.cmd("ColorizerAttachToBuffer")
  end,
})

-- Включить colorizer для всех файлов при входе в буфер
autocmd({"BufEnter"}, {
  group = "ColorizerAutostart",
  callback = function()
    if vim.bo.filetype ~= "" then
      vim.cmd("ColorizerAttachToBuffer")
    end
  end,
})

-- Автоматически выделять при копировании
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Автоматически удалять trailing whitespace
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

print("Neovim конфигурация загружена успешно!")

-- Автоматически включить colorizer после загрузки
vim.defer_fn(function()
  vim.cmd("ColorizerToggle")
end, 100)
