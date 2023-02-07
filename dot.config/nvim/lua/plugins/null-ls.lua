local M = {
  "jose-elias-alvarez/null-ls.nvim",
}

function M.setup(options)
  local nls = require("null-ls")
  nls.setup({
    debounce = 150,
    save_after_format = false,
    sources = {
		-- formatting
		nls.builtins.formatting.shfmt,
		nls.builtins.formatting.black,
		nls.builtins.formatting.autopep8,
		nls.builtins.formatting.isort,
		nls.builtins.formatting.trim_newlines,
		nls.builtins.formatting.prettier.with({
			filetypes = { 'html', 'css', 'yaml', 'markdown', 'json', 'javascript' },
		}),
		-- nls.builtins.formatting.stylelint,
		-- nls.builtins.formatting.stylua,

		-- diagnostics
		-- with_diagnostics_code(nls.builtins.diagnostics.shellcheck),
		-- nls.builtins.diagnostics.djlint,
		nls.builtins.diagnostics.curlylint,
		nls.builtins.diagnostics.tidy,
		-- nls.builtins.diagnostics.shellcheck,
		nls.builtins.diagnostics.flake8,
		-- nls.builtins.diagnostics.mypy,
		nls.builtins.diagnostics.cmake_lint,
		-- nls.builtins.diagnostics.stylelint,
		nls.builtins.diagnostics.trail_space,
		nls.builtins.diagnostics.gitlint.with {
			extra_args = { '--contrib=contrib-title-conventional-commits', '--ignore=body-is-missing' },
		},

		nls.builtins.hover.dictionary,

		-- code actions
		nls.builtins.code_actions.proselint,
		nls.builtins.code_actions.eslint_d,
		nls.builtins.code_actions.gitsigns,
		nls.builtins.code_actions.gitrebase,
		nls.builtins.code_actions.refactoring,
	},
    on_attach = options.on_attach,
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
  })
end

function M.has_formatter(ft)
  local sources = require("null-ls.sources")
  local available = sources.get_available(ft, "NULL_LS_FORMATTING")
  return #available > 0
end

return M
