local M = {
"neovim/nvim-lspconfig",
dependencies = {
	{ "RRethy/vim-illuminate" },
},
config = function ()	
require("config.lsp.handlers").setup()
require("config.lsp.lsp_signature")
require("config.lsp.null-ls")
require("config.lsp.mason")
end
}
return M