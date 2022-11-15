local null_ls = require("null-ls")

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			return client.name ~= "tsserver"
		end,
		bufnr = bufnr,
	})
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

--[[ https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#formatting ]]
local formatting = null_ls.builtins.formatting
--[[ https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#diagnostics ]]
local linters = null_ls.builtins.diagnostics
--[[ https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#code-actions ]]
local code_actions = null_ls.builtins.code_actions
--[[ https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#hover ]]
local hover = null_ls.builtins.hover

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier,
		formatting.stylelint,
		formatting.stylua,
		formatting.beautysh,
		hover.dictionary,
		hover.printenv,
		code_actions.shellcheck,
		linters.luacheck,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
})
