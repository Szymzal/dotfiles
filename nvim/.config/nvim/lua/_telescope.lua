require('telescope').setup {
	defaults = {
		file_sorter	= require('telescope.sorters').get_fzy_sorter,
		prompt_prefix = ' >',
		color_devicons = true,

		file_previewer = require('telescope.previewers').vim_buffer_cat.new,
		grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
		qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

		file_ignore_patterns = { "build\\Debug", "build\\Release", '.obj', '.pdb' },

		mappings = {
			i = {
				["<C-x>"] = false,
			},
		}
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		}
	}
}

require('telescope').load_extension('fzy_native')
