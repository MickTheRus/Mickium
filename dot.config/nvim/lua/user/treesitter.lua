local M = {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			event = "VeryLazy",
		},
    {
      "Fymyte/tree-sitter-rasi",
      lazy = false,
      ft = "rasi",
    },
	},
}
function M.config()
	local configs = require("nvim-treesitter.configs")

	configs.setup({
		ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "python" }, -- put the language you want in this array
		-- ensure_installed = "all", -- one of "all" or a list of languages
		ignore_install = { "" }, -- List of parsers to ignore installing
		sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
		highlight = {
			enable = true, -- false will disable the whole extension
		},
		autopairs = {
			enable = true,
		},
		indent = { enable = true },
		matchup = {
			enable = { "astro" },
			disable = { "lua" },
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
	})
end

return M
