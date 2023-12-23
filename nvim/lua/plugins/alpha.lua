local logo = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}


local footer = [[
 /\                 /\
/ \'._   (\_/)   _.'/ \
|.''._'--(o.o)--'_.''.|
 \_ / `;=/ " \=;` \ _/
   `\__| \___/ |__/`
        \(_|_)/
         " ` "
]]

return {
    'goolord/alpha-nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function ()
		local alpha = require('alpha')
		local dashboard = require('alpha.themes.dashboard')

		-- Set header logo
		dashboard.section.header.val = logo

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button( "e", "		>	New file" , ":ene <BAR><CR>"),
			dashboard.button( "f", "		>	Find file", ":Telescope find_files<CR>"),
			dashboard.button( "r", "		>	Recent"   , ":Telescope oldfiles<CR>"),
			dashboard.button( "q", "󰛉		>	Quit NVIM", ":qa<CR>"),
		}

		dashboard.section.footer.val = footer

		alpha.setup(dashboard.opts)
	end
}
