local util = require("neodev.util")

require("neodev").setup({
	override = function(root_dir, library)
		if util.has_file(root_dir, "~/.config/nvim") or util.has_file(root_dir, "~/Mickium/dot.config/nvim") then
			library.enabled = true
			library.plugins = true
		end
	end,
})
