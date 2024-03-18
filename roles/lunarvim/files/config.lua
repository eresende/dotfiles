-- Plugins
lvim.plugins = {
    "AckslD/swenv.nvim",
    "stevearc/dressing.nvim",
    "mfussenegger/nvim-dap-python",
    "nvim-neotest/neotest",
    "nvim-neotest/neotest-python",
    "ThePrimeagen/harpoon",
    "bluz71/vim-moonfly-colors",
    "bluz71/vim-nightfly-colors",
}

-- VIM options
vim.opt.cmdheight = 2
vim.opt.colorcolumn = "120"
vim.opt.cursorcolumn = true
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- Use 'za' to collapse fold
-- vim.opt.foldmethod = "expr"
vim.opt.iskeyword:append("-")
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = true

-- LunarVIM options
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "tokyonight"
vim.g.tokyonight_style = "nightfly"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.insert_mode["jk"] = "<esc>"
lvim.keys.normal_mode["<S-c>c"] = ":set colorcolumn=75<CR>"
lvim.keys.normal_mode["<S-c>C"] = ":set colorcolumn=120<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<C-n>"] = ":set number! relativenumber!<CR>"

-- Resize with arrows
lvim.keys.normal_mode["<C-S-Up>"] = ":resize -2<CR>"
lvim.keys.normal_mode["<C-S-Down>"] = ":resize +2<CR>"
lvim.keys.normal_mode["<C-S-Left>"] = ":vertical resize -2<CR>"
lvim.keys.normal_mode["<C-S-Right>"] = ":vertical resize +2<CR>"

-- Disble arrow keys so I get used to h, j, k, l for navigation
-- except when on insert mode
for _, mode in pairs({ 'n', 'v', 'x' }) do
    for _, key in pairs({ '<Up>', '<Down>', '<Left>', '<Right>' }) do
        vim.keymap.set(mode, key, '<nop>')
    end
end

-- Telescope config
lvim.builtin.telescope.defaults.initial_mode = "insert"
lvim.builtin.telescope.defaults.layout_config.preview_cutoff = 120
lvim.builtin.telescope.defaults.layout_config.prompt_position = "bottom"
lvim.builtin.telescope.defaults.layout_config.width = 0.75
lvim.builtin.telescope.defaults.layout_strategy = "horizontal"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
    -- for input mode
    i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
    },
    -- for normal mode
    n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
    },
}

-- Treesitter plugins
lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "json",
    "lua",
    "python",
    "css",
    "rust",
    "java",
    "yaml",
}

-- Formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup({
    { name = "black" },
})

-- Linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup({
    { command = "flake8", args = { "--ignore-E203" }, filetypes = { "python" } }
})

-- Python Virtual Envs
require('swenv').setup({
    post_set_venv = function()
        vim.cmd("LspRestart")
    end,
})
lvim.builtin.which_key.mappings["C"] = {
    name = "Python",
    c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}

-- Python Debugging
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")

-- setup testing
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      -- Extra arguments for nvim-dap configuration
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
      dap = {
        justMyCode = false,
        console = "integratedTerminal",
      },
      args = { "--log-level", "DEBUG", "--quiet" },
      runner = "pytest",
    })
  }
})

lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>",
  "Test Method" }
lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
  "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
lvim.builtin.which_key.mappings["dF"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }

