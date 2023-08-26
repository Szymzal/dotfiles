return {
  {
    "sainnhe/sonokai",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd([[ let g:sonokai_style = 'andromeda' ]])
      vim.cmd([[ let g:sonokai_better_performance = 1 ]])
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "sonokai",
    },
  },
}
