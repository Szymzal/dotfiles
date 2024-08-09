local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>vim", function()
  require("telescope.builtin").find_files({
    prompt_title = "<vimrc>",
    cwd = vim.fn.stdpath("config"),
  })
end, opts)
