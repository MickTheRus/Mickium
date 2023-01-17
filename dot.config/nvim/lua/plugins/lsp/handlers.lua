local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local signs = {

		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false, -- disable virtual text
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end
require("key-menu").set("n", "f")

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
keymap("n", "fD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Declaration" }, opts)
keymap("n", "fd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Definition" }, opts)
keymap("n", "fK", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Description" }, opts)
keymap("n", "fI", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Implementation" }, opts)
keymap("n", "fr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "References" }, opts)
keymap("n", "fl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Diagnostic" }, opts)
M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
	end

	require("illuminate").on_attach(client, bufnr)
	require("lsp_signature").on_attach(client, bufnr)
 	require("sqls").on_attach(client, bufnr)
end

return M
