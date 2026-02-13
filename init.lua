---@diagnostic disable: undefined-global

-- Basic
vim.opt.backspace = { "indent", "eol", "start" }

-- Appearance
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.laststatus = 2
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.display = "lastline"
vim.opt.updatetime = 1000
vim.opt.termguicolors = true

-- Indent / Tab
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Others
vim.opt.virtualedit:append("block")
vim.opt.belloff = "all"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.splitright = true
vim.opt.clipboard:append("unnamed")
vim.o.mouse = ""

-- Keymap
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "<Left>", "<C-w>h")
vim.keymap.set("n", "<Down>", "<C-w>j")
vim.keymap.set("n", "<Up>", "<C-w>k")
vim.keymap.set("n", "<Right>", "<C-w>l")
vim.keymap.set("n", "<Home>", "<C-w><")
vim.keymap.set("n", "<PageDown>", "<C-w>+")
vim.keymap.set("n", "<PageUp>", "<C-w>-")
vim.keymap.set("n", "<End>", "<C-w>>")
vim.keymap.set("n", "<ESC><ESC>", ":nohlsearch<CR>", { silent = true })
vim.keymap.set('n', '<Leader>q', function()
  local qf_win = vim.fn.getqflist({winid = 0}).winid
  if qf_win ~= 0 then
    vim.cmd('cclose')
  end

  local loc_win = vim.fn.getloclist(0, {winid = 0}).winid
  if loc_win ~= 0 then
    vim.cmd('lclose')
  end

  local quickrun_buf = vim.fn.bufwinnr('quickrun://output')
  if quickrun_buf ~= -1 then
    vim.api.nvim_buf_delete(vim.fn.bufnr('quickrun://output'), {force = true})
  end
end, { silent = true, noremap = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Binary file handling
vim.api.nvim_create_augroup("Binary", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = "Binary",
  callback = function()
    if vim.opt_local.binary:get() then
      vim.cmd("%!xxd")
      vim.opt_local.filetype = "xxd"
      vim.opt_local.modifiable = true
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = "Binary",
  callback = function()
    if vim.opt_local.binary:get() then
      vim.cmd("%!xxd -r")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "Binary",
  callback = function()
    if vim.opt_local.binary:get() then
      vim.cmd("%!xxd")
      vim.opt_local.modified = false
    end
  end,
})

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { "cocopon/iceberg.vim" },
  { "vim-airline/vim-airline" },

  -- Movement / Editing
  {
    "easymotion/vim-easymotion",
    keys = {
      { "<leader>e", "<Plug>(easymotion-bd-e)", mode = "n" },
      { "<leader>w", "<Plug>(easymotion-bd-w)", mode = "n" },
      { "<leader>f", "<Plug>(easymotion-f)",  mode = "n" },
      { "<leader>F", "<Plug>(easymotion-F)",  mode = "n" },
      { "<leader>j", "<Plug>(easymotion-j)",  mode = "n" },
      { "<leader>k", "<Plug>(easymotion-k)",  mode = "n" },
    },
    init = function() vim.g.EasyMotion_smartcase = 1 end,
  },
  {
    "ntpeters/vim-better-whitespace",
    event = { "BufWritePre", "InsertLeave" },
    init = function()
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_whitespace_confirm = 0
    end,
    config = function()
      vim.schedule(function()
        vim.cmd("EnableWhitespace")
      end)
    end,
  },
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-commentary", event = "VeryLazy" },

  -- Search
  { "junegunn/fzf", build = ":call fzf#install()" },
  {
    "junegunn/fzf.vim",
    keys = {
      { ",fb", ":Buffers<CR>", mode = "n" },
      { ",fc", ":Commands<CR>", mode = "n" },
      { ",ff", ":Files<CR>",  mode = "n" },
      { ",fh", ":History<CR>", mode = "n" },
      { ",fl", ":Lines<CR>",  mode = "n" },
      { ",ft", ":Tags<CR>",   mode = "n" },
      { ",fg", ":Rg<CR>", mode = "n" },
      { ",fG", ":SearchWord<CR>", mode = "n",
        { silent = true, desc = "Search current word (rg)" }
      }
    }
  },

  -- Syntax / Highlight
  -- LSP + Completion
  { "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile" } },
  { "hrsh7th/cmp-nvim-lsp", event = "VeryLazy" },
  { "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "bashls",
        "clangd",
        "cmake",
        "docker_language_server",
        'docker_compose_language_service',
        'jsonls',
        'lua_ls',
        "pyright"
      }

    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = {
          ["<C-n>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback() -- Fallback to built-in Vim <C-n> completion
            end
          end,

          ["<C-p>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback() -- Fallback to built-in Vim <C-p> completion
            end
          end,

          ["<Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback() -- Fallback to normal Tab behavior (indent, etc.)
            end
          end,

          ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback() -- Fallback to default Shift-Tab behavior
            end
          end,

          ["<CR>"] = function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              fallback() -- Fallback to normal Enter behavior
            end
          end,
        },

        sources = {
          { name = "nvim_lsp" }, -- LSP completion source
          { name = "buffer" },   -- Buffer words completion source
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "t9md/vim-quickhl",
    keys = {
      { "<space>m", "<Plug>(quickhl-manual-this)", mode = { "n", "x" } },
      { "<space>M", "<Plug>(quickhl-manual-reset)", mode = { "n", "x" } },
    },
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
      require("gitsigns").setup({ update_debounce = 1000 })
    end,
  },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>g", "<cmd>LazyGit<CR>", desc = "LazyGit" } },
  },

  -- Task runner
  {
    "stevearc/overseer.nvim",
    version = "v1.6.0",
    cmd = { "OverseerToggle", "OverseerRun" },
    keys = {
      { "<leader>R", "<cmd>OverseerToggle<CR>", desc = "Toggle Overseer" },
      {
        "<leader>r",
        function() require("overseer").run_template({ name = "quickrun_" .. vim.bo.filetype }) end,
        desc = "QuickRun current file",
      },
    },
    config = function()
      require("overseer").setup({ templates = { "builtin", "user.quickrun" } })
    end,
  },
}

-- Merge local plugin settings if available
local local_init = vim.fn.stdpath("config") .. "/init.local.lua"
if vim.fn.filereadable(local_init) == 1 then
  local ok, res = pcall(dofile, local_init)
  if ok and type(res) == "table" then
    vim.list_extend(plugins, res)
  elseif not ok then
    vim.notify("Failed to load init.local.lua: " .. res, vim.log.levels.WARN)
  end
end

require("lazy").setup(plugins)

-- ------------------------------------------------------------
-- Plugin Configurations
vim.cmd.colorscheme("iceberg")

-- Lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gr", vim.lsp.buf.references)

-- Diagnostic float
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })

    if #diagnostics > 0 then
      table.sort(diagnostics, function(a, b)
        return a.severity < b.severity
      end)
      local diag = diagnostics[1]

      local msg = string.format("[%s] %s",
        vim.diagnostic.severity[diag.severity],
        diag.message:gsub("\n", " ")
      )

      vim.api.nvim_echo({ { msg, "WarningMsg" } }, false, {})
    else
      vim.api.nvim_echo({}, false, {})
    end
  end,
})

-- Search using rg + fzf
if vim.fn.executable("rg") == 1 then
  vim.api.nvim_create_user_command("SearchWord", function()
    local q = vim.fn.expand("<cword>")
    vim.fn["fzf#vim#grep"](
      "rg --column --line-number --no-heading --color=always --smart-case -- .",
      vim.fn["fzf#vim#with_preview"]({ options = "--query=" .. q }),
      0
    )
  end, {})
end

-- Terminal
vim.keymap.set("n", "<Leader>t", function()
  vim.cmd("split | term")
  vim.cmd("startinsert")
end, { noremap = true, silent = true })
