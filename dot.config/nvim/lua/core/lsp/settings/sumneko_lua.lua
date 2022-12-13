local default_workspace = {
	library = {
		vim.fn.expand("$VIMRUNTIME"),
		require("neodev.config").types(),
	},
	maxPreload = 5000,
	preloadFileSize = 10000,
}
return {
	settings = {
		Lua = {
			format = {
				enable = false,
			},
			diagnostics = {
				globals = { "vim", "hs", "reload", "packer_plugins" },
			},
			runtime = { version = "LuaJit", special = { reload = "reuire" } },
			telemetry = {
				enable = false,
			},
			workspace = default_workspace,
		},
	},
}
