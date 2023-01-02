require("fidget").setup({})

local servers = {
	lsp = {
		"sumneko_lua",
		"marksman",
		"clangd",
		"cssls",
		"html",
		"tsserver",
		"pyright",
		"bashls",
		"jsonls",
		"yamlls",
		"omnisharp",
	},
	dap = { "vscode-bash-debug", "vscode-go" },
	formatter = { "csharpier", "stylua", "black", "prettier" },
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup({ settings, ensure_installed = servers })
require("mason-lspconfig").setup({
  ensure_installed = servers.lsp,
  automatic_installation = true,
})

require("mason-nvim-dap").setup({
  ensure_installed = servers.dap,
  automatic_installation = true,
})

require("mason-null-ls").setup({
  ensure_installed = servers.formatter,
  automatic_installation = true,
})


vim.api.nvim_create_autocmd("User", {
	pattern = "MasonToolsUpdateCompleted",
	callback = function()
		vim.schedule(function()
			print("mason-tool-installer has finished")
		end)
	end,
})
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers.lsp) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
