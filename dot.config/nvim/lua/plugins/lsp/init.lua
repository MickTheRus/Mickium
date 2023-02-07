local M = {
	"neovim/nvim-lspconfig",
	name = "lsp",
	event = "BufReadPre",
	dependencies = {
		{ 'hrsh7th/cmp-nvim-lsp', event = 'LspAttach' },
		{ 'ray-x/lsp_signature.nvim', enabled = true, event = 'InsertEnter' },
		{
			'Issafalcon/lsp-overloads.nvim',
			event = 'InsertEnter'
		},
		{
			'mrshmllow/document-color.nvim',
			event   = 'LspAttach',
			config  = function ()
				require('document-color').setup({
					mode = 'background',
				})
			end
		},
		{
			'dnlhc/glance.nvim',
			disable = false,
			event = 'LspAttach',
			config = function()
				require('glance').setup({
					border = {
						enable      = true,
						top_char    = '─',
						bottom_char = '─',
					},
				})
			end,
		},
		{
			'lvimuser/lsp-inlayhints.nvim',
			enabled = true,
			config = function ()
				local default_config = {
					inlay_hints = {
						parameter_hints = {
							show = true,
						},
						type_hints = {
							show = true,
						},
						only_current_line = true,
						label_formatter = function(labels, kind, opts, client_name)
							if kind == 2 and not opts.parameter_hints.show then
								return ""
							elseif not opts.type_hints.show then
								return ""
							end

							return table.concat(labels or {}, ", ")
						end,
						virt_text_formatter = function(label, hint, opts, client_name)
							if client_name == "sumneko_lua" then
								if hint.kind == 2 then
									hint.paddingLeft = false
								else
									hint.paddingRight = false
								end
							end

							local virt_text = {}
							virt_text[#virt_text + 1] = hint.paddingLeft and { " ", "Normal" } or nil
							virt_text[#virt_text + 1] = { label, opts.highlight }
							virt_text[#virt_text + 1] = hint.paddingRight and { " ", "Normal" } or nil

							return virt_text
						end,

						-- highlight group
						highlight = "LspInlayHint",
					},
					enabled_at_startup = true,
					debug_mode = false,
				}
				require("lsp-inlayhints").setup({default_config})

				--[[ vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
				vim.api.nvim_create_autocmd("LspAttach", {
					group = "LspAttach_inlayhints",
					callback = function(args)
						if not (args.data and args.data.client_id) then
							return
						end

						local bufnr = args.buf
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						require("lsp-inlayhints").on_attach(client, bufnr)
					end,
				}) ]]
			end
		}
	}
}

function M.config()
	require('plugins.lsp.pylance')

	--[[ require("neodev").setup({
		debug = true,
		experimental = {
			pathStrict = true,
		},
		library = {
			runtime = "~/projects/neovim/runtime/",
		},
	}) ]]
	require("mason")
	require("plugins.lsp.diagnostics").setup()

	local function on_attach(client, bufnr)
		local lsp_signature_cfg = {
			bind 			= true,
			wrap            = true,
			floating_window = false,
			doc_lines       = 0,
			hint_enable     = true,
			hint_prefix     = '🐼 ',
			hint_scheme     = 'String',
			hi_parameter    = 'LspSignatureActiveParameter',
			always_trigger  = true,
			handler_opts    = {
				border = 'rounded'
			}
		}
		require('lsp_signature').on_attach(lsp_signature_cfg, bufnr)

		if client.server_capabilities.definitionProvider then
			vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
		end

		require("lsp-inlayhints").on_attach(client, bufnr)

		client.server_capabilities.semanticTokensProvider = nil

		if client.server_capabilities.colorProvider then
			require("document-color").buf_attach(bufnr)
		end

		if client.server_capabilities.documentHighlightProvider then
			local group = vim.api.nvim_create_augroup("DocumentHighlight", {})
			vim.api.nvim_create_autocmd("CursorHold", {
				group = group,
				buffer = 0,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd("CursorMoved", {
				group = group,
				buffer = 0,
				callback = vim.lsp.buf.clear_references,
			})
		end

		-- require("nvim-navic").attach(client, bufnr)
		require("plugins.lsp.formatting").setup(client, bufnr)
		require("plugins.lsp.keys").setup(client, bufnr)
	end

	---@type lspconfig.options
	local servers = {
		bashls = {},
		clangd = {
			cmd = { '/bin/clangd', '--background-index', '--header-insertion=iwyu',
			'--completion-style=bundled', '--function-arg-placeholders', '--malloc-trim',
			'--pch-storage=memory', '--clang-tidy', '--header-insertion-decorators',
			'--all-scopes-completion', '--offset-encoding=utf-16', '--inlay-hints=true'
		},
		flags = {
			debounce_text_changes = 150,
		};
		init_options = {
			clangdFileStatus     = true,
			usePlaceholders      = true,
			completeUnimported   = true,
			semanticHighlighting = true,
			InlayHints = {
				Enabled        = true,
				ParameterNames = true,
				DeducedTypes   = true,
			},
		};
	},

	-- Web Dev
		cssls = {},
		cssmodules_ls = {},
		tailwindcss = {},
		emmet_ls = {},
		yamlls = {},
		eslint = {},
		html = {
			settings = {
				html = {
					format = {
						templating     = true,
						wrapLineLength = 120,
						wrapAttributes = 'auto',
					},
					hover = {
						documentation = true,
						references    = true,
					},
				},
			},
		},

		-- python
		-- pyright = {},
		jedi_language_server = {},
		pylance = {},
		tsserver = {},

		-- lua
		sumneko_lua = {
			single_file_support = true,
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = false,
					},
					completion = {
						workspaceWord = true,
						callSnippet = "Replace",
					},
					misc = {
						parameters = {
							"--log-level=trace",
						},
					},
					diagnostics = {
						-- enable = false,
						globals = { 'vim' },
						disable = {
							"missing-parameter",
							"cast-local-type",
							"param-type-mismatch",
							"assign-type-mismatch",
							"undefined-field",
							"redundant-parameter",
							"no-unknown"
						},
						groupSeverity = {
							strong = "Warning",
							strict = "Warning",
						},
						groupFileStatus = {
							["ambiguity"]  = "Opened",
							["await"]      = "Opened",
							["codestyle"]  = "None",
							["duplicate"]  = "Opened",
							["global"]     = "Opened",
							["luadoc"]     = "Opened",
							["redefined"]  = "Opened",
							["strict"]     = "Opened",
							["strong"]     = "Opened",
							["type-check"] = "Opened",
							["unbalanced"] = "Opened",
							["unused"]     = "Opened",
						},
						unusedLocalExclude = { "_*" },
					},
					format = {
						enable = false,
						defaultConfig = {
							indent_style = "space",
							indent_size  = "2",
							continuation_indent_size = "2",
						},
					},
				},
			},
		},

		vimls = {},
	}

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	local win = require("lspconfig.ui.windows")
	local _default_opts = win.default_opts
	win.default_opts = function(options)
		local opts = _default_opts(options)
		opts.border = "rounded"
		return opts
	end

	---@type _.lspconfig.options
	local options = {
		debug             = false,
		debounce          = 150,
		save_after_format = false,
		on_init = function(new_client, _)
			new_client.offset_encoding = 'utf-16'
		end,
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	}

	for server, opts in pairs(servers) do
		opts = vim.tbl_deep_extend("force", {}, options, opts or {})
		require("lspconfig")[server].setup(opts)
	end

	require("plugins.null-ls").setup(options)
end

return M
