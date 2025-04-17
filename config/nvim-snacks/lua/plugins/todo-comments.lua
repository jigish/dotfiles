return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    highlight = {
      pattern = {
        [[.*<(KEYWORDS)\s*:]], -- TODO: something
        [[.*<(KEYWORDS)$]], -- TODO
        [=[.*<(KEYWORDS)\[.*\]:]=], -- TODO[jigish]: yet another thing
      }
    },
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
      info = { "DiagnosticInfo", "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
      test = { "Identifier", "#FF00FF" }
    },
  }
}
