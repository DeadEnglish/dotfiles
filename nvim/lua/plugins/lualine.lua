local options = {
	theme = "everfrost"
}

return {
	'nvim-lualine/lualine.nvim',
	config = function() 
		require('lualine').setup({options})
	end
}
