local M = {
"neovim/nvim-lspconfig",
dependencies = {
	{ "RRethy/vim-illuminate" },
},
config = function ()	
require("plugins.lsp.handlers").setup()
require("plugins.lsp.lsp_signature")
require("plugins.lsp.null-ls")
require("plugins.lsp.mason")
end
}
return M