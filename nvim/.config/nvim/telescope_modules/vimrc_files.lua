local vimrc = {}
vimrc.search_dotfiles = function()
	require("telescope.builtin").find_files({
		prompt_title = "<vimrc>",
		cwd = "~/.config/nvim/",
	})
end

return vimrc
