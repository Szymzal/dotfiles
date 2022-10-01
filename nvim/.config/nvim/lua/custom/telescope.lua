local M = {}
M.search_vimrc = function()
    require("telescope.builtin").find_files({
        prompt_title = "<vimrc>",
        cwd = vim.fn.stdpath('config')
    })
end

return M
