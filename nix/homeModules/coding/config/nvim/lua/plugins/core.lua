return {
  {
    "sainnhe/edge",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd([[ let g:edge_style = 'default' ]])
      vim.cmd([[ let g:edge_better_performance = 1 ]])
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "edge",
    },
  },
}