require('telescope').setup {
    defaults = {
        prompt_prefix = ' >',

        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        file_ignore_patterns = { ".exe", "\\target\\", '.git' },
        mappings = {
            i = {
                ["<C-x>"] = false,
            }
        }
    }
}
