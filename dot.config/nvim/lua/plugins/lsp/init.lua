local M = {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		"folke/neodev.nvim",
	},
	config = function(_, opts)
		local utils = require("utils")
		local mason_lspconfig = require("mason-lspconfig")
		local lspconfig = require("lspconfig")
		local lsp_utils = require("plugins.lsp.lsp-utils")
		lsp_utils.setup()

		require("neodev").setup({
			-- add any options here, or leave empty to use the default settings
		})

		mason_lspconfig.setup({
			ensure_installed = utils.lsp_servers,
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					on_attach = lsp_utils.on_attach,
					capabilities = lsp_utils.capabilities,
				})
			end,
			["pyright"] = function()
				lspconfig.pyright.setup({
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "off",
							},
						},
					},
				})
			end,
			["clangd"] = function()
				local capabilities_cpp = lsp_utils.capabilities
				capabilities_cpp.offsetEncoding = { "uts-16" }
				lspconfig.clangd.setup({
					on_attach = lsp_utils.on_attach,
					capabilities = capabilities_cpp,
				})
			end,
			["sumneko_lua"] = function()
				lspconfig.sumneko_lua.setup({
					diagnostics = {
						globals = {
							"vim",
							"awesome",
							"button",
							"dbus",
							"drawable",
							"drawin",
							"key",
							"keygrabber",
							"mousegrabber",
							"selection",
							"tag",
							"window",
							"table.unpack",
							"math.atan2",
							"screen",
							"mouse",
							"root",
							"client",
						},
					},
					runtime = {
						version = "LuaJIT",
						special = {
							reload = "require",
						},
					},
					telemetry = { enable = false },
					library = {
						vim.fn.expand("$VIMRUNTIME"),
						require("neodev.config").types(),
						"${3rd}/busted/library",
						"${3rd}/luassert/library",
						["/usr/share/awesome/lib"] = true,
					},
				})
			end,
		})
	end,
}

return M
