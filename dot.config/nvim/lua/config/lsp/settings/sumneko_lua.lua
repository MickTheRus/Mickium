--- @type lspconfig.options.sumneko_lua
local sumneko_lua = {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
				checkThirdParty = false,
			},
			globals = { "vim" },
			hint = {
				enable = true,
				setType = true,
			},
			format = {
				enable = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

return sumneko_lua
