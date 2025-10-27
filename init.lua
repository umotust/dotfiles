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
-- Color
vim.opt.termguicolors = true
vim.cmd([[
  highlight! Normal ctermbg=NONE guibg=NONE
  highlight! NonText ctermbg=NONE guibg=NONE
  highlight! LineNr ctermbg=NONE guibg=NONE
]])
-- Tab/Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
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
vim.opt.ttyfast = true
vim.opt.clipboard:append("unnamed")
vim.o.mouse = ""
-- Key map
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

-- Lazy.nvim setup (Plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)
local plugins = {
  -- UI / Theme
  { "cocopon/iceberg.vim" },
  { "vim-airline/vim-airline" },

  -- Movement / Editing
  { "easymotion/vim-easymotion" },
  { "ntpeters/vim-better-whitespace" },
  { "tpope/vim-surround" },
  { "tpope/vim-commentary" },

  -- Search
  { "junegunn/fzf" },
  { "junegunn/fzf.vim" },

  -- Syntax / Highlight
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "t9md/vim-quickhl"},

  -- LSP + Completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "mason-org/mason-lspconfig.nvim",
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

  -- Git
  { "lewis6991/gitsigns.nvim" },
  { "tpope/vim-fugitive" },
  { "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>g", "<cmd>LazyGit<CR>", desc = "LazyGit" }
    }
  },

  -- Task runner (QuickRun replacement)
  { "stevearc/overseer.nvim" },
}

-- Allow user to provide a local file that RETURNS a table of additional plugin specs.
-- The recommended shape for `init.local.lua` is:
--   return {
--     { "author/plugin", config = function() ... end },
--   }
local local_init = vim.fn.stdpath("config") .. "/init.local.lua"
if vim.fn.filereadable(local_init) == 1 then
  local ok, res = pcall(dofile, local_init)
  if not ok then
    vim.notify("Failed to load init.local.lua: " .. res, vim.log.levels.WARN)
  else
    -- If the local file returns a table, merge it into the main plugins list.
    -- If it returns nil or another type, that's fine — dofile already executed
    -- the file so any side-effect (keymaps, settings) will have run.
    if type(res) == "table" then
      for _, p in ipairs(res) do table.insert(plugins, p) end
    end
  end
end

require("lazy").setup(plugins)

-- ------------------------------------------------------------
-- Plugin Configurations
vim.cmd("colorscheme iceberg")

-- Lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: [G]oto [D]efinition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "LSP: [G]oto [D]eclaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: [G]oto [R]eference" })

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

-- Treesitter: syntax highlighting
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
})

-- Gitsigns: git diff indicators
require("gitsigns").setup({
  update_debounce = 200,
})

-- LSP and completion setup
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
})

-- Search
vim.keymap.set("n", ",ff", ":<C-u>Files<CR>")
vim.keymap.set("n", ",fb", ":<C-u>Buffers<CR>")
vim.keymap.set("n", ",fh", ":<C-u>History<CR>")
vim.keymap.set("n", ",fl", ":<C-u>Lines<CR>")
vim.keymap.set("n", ",ft", ":<C-u>Tags<CR>")

local function get_search_word()
  local query = ""
  if query == "" then
    query = vim.fn.expand("<cword>")
  end
  return query
end

if vim.fn.executable("rg") == 1 then
  vim.keymap.set("n", ",fg", ":Rg<CR>", { silent = true })

  vim.api.nvim_create_user_command("SearchWord", function(opts)
    local query = get_search_word()
    vim.fn["fzf#vim#grep"](
      "rg --column --line-number --no-heading --color=always --smart-case -- .",
      vim.fn["fzf#vim#with_preview"]({ options = "--query=" .. query }),
      opts.bang and 1 or 0
    )
  end, { bang = true, nargs = "?" })

  vim.keymap.set("n", ",fG", ":SearchWord<CR>", { silent = true, desc = "Search current word (rg)" })
end

-- Easymotion settings
vim.g.EasyMotion_smartcase = 1
vim.keymap.set("n", "<leader>e", "<Plug>(easymotion-bd-e)", { remap = true })
vim.keymap.set("n", "<leader>w", "<Plug>(easymotion-bd-w)", { remap = true })
vim.keymap.set("n", "<leader>f", "<Plug>(easymotion-f)", { remap = true })
vim.keymap.set("n", "<leader>F", "<Plug>(easymotion-F)", { remap = true })
vim.keymap.set("n", "<leader>j", "<Plug>(easymotion-j)", { remap = true })
vim.keymap.set("n", "<leader>k", "<Plug>(easymotion-k)", { remap = true })

-- Terminal
vim.keymap.set("n", "<Leader>t", function()
  vim.cmd(":split | term")
  vim.cmd("startinsert")
end, { noremap = true, silent = true })

-- quickhl
vim.keymap.set("n", "<space>m", "<Plug>(quickhl-manual-this)", { remap = true })
vim.keymap.set("x", "<space>m", "<Plug>(quickhl-manual-this)", { remap = true })
vim.keymap.set("n", "<space>M", "<Plug>(quickhl-manual-reset)", { remap = true })
vim.keymap.set("x", "<space>M", "<Plug>(quickhl-manual-reset)", { remap = true })

-- Whitespace cleanup
vim.g.strip_whitespace_on_save = 1
vim.g.strip_whitespace_confirm = 0

-- Local configurations
local local_init = vim.fn.stdpath("config") .. "/init.local.lua"
if vim.fn.filereadable(local_init) == 1 then
    local ok, err = pcall(dofile, local_init)
    if not ok then
        vim.notify("Failed to load init.local.lua: " .. err, vim.log.levels.WARN)
    end
end
