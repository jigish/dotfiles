return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    animate = { enabled = true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    --explorer = { enabled = true },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    notify = { enabled = true },
    picker = { enabled = true },
    quickfile = { enabled = true },
    rename = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    toggle = { enabled = true },
    util = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    -- pickers
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<localleader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<C-p>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<C-b>", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<C-g>", function() Snacks.picker.git_files() end, desc = "Git Files" },
    { "<C-l>", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>aa", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<localleader>aa", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>Q", function() Snacks.picker.qflist() end, desc = "Quickfix" },
    { "<localleader>Q", function() Snacks.picker.qflist() end, desc = "Quickfix" },
    -- lsp
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<localleader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "<localleader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- buffer management
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<localleader>bd", function() Snacks.picker.grep() end, desc = "Delete Buffer" },
    -- file explorer
    --{ "<leader>f", function() Snacks.explorer.open() end, desc = "File Explorer" },
    --{ "<localleader>f", function() Snacks.explorer.open() end, desc = "File Explorer" },
    -- git browse
    { "<leader>go", function() Snacks.gitbrowse.open() end, desc = "Open Repo in Browser" },
    { "<localleader>go", function() Snacks.gitbrowse.open() end, desc = "Open Repo in Browser" },
    -- lazygit
    { "<leader>gg", function() Snacks.lazygit.open() end, desc = "Open LazyGit" },
    { "<localleader>gg", function() Snacks.lazygit.open() end, desc = "Open LazyGit" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Open Git Log" },
    { "<localleader>gl", function() Snacks.lazygit.log() end, desc = "Open Git Log" },
    { "<leader>gL", function() Snacks.lazygit.log() end, desc = "Open Git Log (File)" },
    { "<localleader>gL", function() Snacks.lazygit.log() end, desc = "Open Git Log (File)" },
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    { "<localleader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
  }
}
