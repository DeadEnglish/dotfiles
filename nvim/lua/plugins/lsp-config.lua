local mason_config = {
	ui = {
		border = "rounded",
	},
}

local mason_lsp_config = {
	ensure_installed = {
		-- Astro
		"astro",
		-- CSS
		"cssls",
		-- ESLint
		"eslint",
		-- GO
		"gopls",
		-- HTML
		"html",
		-- JSON
		"jsonls",
		-- LUA
		"lua_ls",
		-- Markdown
		"marksman",
		-- Tailwind
		"tailwindcss",
		-- Typescript
		"vtsls",
		-- YAML
		"yamlls",
	},
	automatic_installation = true,
}

local mason_tool_installer_config = {
	ensure_installed = {
		"stylua",
		"prettier",
		"eslint_d",
		"goimports",
	},
}

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "Mason" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer",
			"saghen/blink.cmp",
		},
		config = function()
			require("mason").setup(mason_config)
			-- setup with ensure installed files
			require("mason-tool-installer").setup(mason_tool_installer_config)
			require("mason-lspconfig").setup(mason_lsp_config)

			vim.o.winborder = "rounded"

			local function vtsls_on_publish_diagnostics_override(_, result, ctx, config)
				local filtered_diagnostics = {}

				for _, diagnostic in ipairs(result.diagnostics) do
					local found = false
					if not found then
						table.insert(filtered_diagnostics, diagnostic)
					end
				end

				result.diagnostics = filtered_diagnostics

				vim.lsp.handlers["textDocument/publishDiagnostics"](_, result, ctx, config)
			end

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				astro = {},
				cssls = {},
				eslint = {},
				html = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim", "buffer_number" },
							},
						},
					},
				},
				marksman = {},
				tailwindcss = {},
				vtsls = {
					settings = {
						typescript = {
							tsserver = { maxTsServerMemory = 12288 },
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "all" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = true },
							},
						},
						javascript = {
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "all" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = true },
							},
						},
					},
					handlers = {
						["textDocument/publishDiagnostics"] = vtsls_on_publish_diagnostics_override,
					},
				},
				yamlls = {},
				gopls = {
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							staticcheck = true,
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},
			}
			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					-- Keybindings
					vim.keymap.set(
						"n",
						"<leader>rn",
						vim.lsp.buf.rename,
						{ desc = "rename", buffer = args.buf, noremap = true, silent = true }
					)
					vim.keymap.set(
						{ "n" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ desc = "View code actions", buffer = args.buf }
					)
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						{ desc = "Go to definition", buffer = args.buf }
					)

					-- Telescope specific
					vim.keymap.set(
						"n",
						"gr",
						require("telescope.builtin").lsp_references,
						{ desc = "Find all references", buffer = args.buf }
					)
					vim.keymap.set(
						"n",
						"gi",
						require("telescope.builtin").lsp_implementations,
						{ desc = "find all implementations", buffer = args.buf }
					)

					vim.keymap.set(
						"n",
						"<leader>bs",
						require("telescope.builtin").lsp_document_symbols,
						{ desc = "Buffer symbols", buffer = args.buf }
					)

					vim.keymap.set(
						"n",
						"<leader>ps",
						require("telescope.builtin").lsp_workspace_symbols,
						{ desc = "Project symbols", buffer = args.buf }
					)
					vim.keymap.set(
						"n",
						"<leader>k",
						vim.lsp.buf.hover,
						{ desc = "Hover Documentation", buffer = args.buf }
					)
					vim.keymap.set(
						"n",
						"<leader>ih",
						function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end,
						{ desc = "Toggle inlay hints", buffer = args.buf }
					)
					vim.lsp.inlay_hint.enable(false)
				end,
			})

			-- Iterate over our servers and set them up
			for name, config in pairs(servers) do
				vim.lsp.config(name, {
					autostart = config.autostart,
					cmd = config.cmd,
					capabilities = capabilities,
					filetypes = config.filetypes,
					handlers = config.handlers,
					settings = config.settings,
					root_dir = config.root_dir,
				})
			end
			-- Disable ts_ls to prevent it from auto-starting alongside vtsls
			vim.lsp.enable("ts_ls", false)

			-- Configure diagnostics border
			vim.diagnostic.config({
				virtual_text = {
					spacing = 2,
					source = "if_many",
					prefix = "●",
				},
				float = {
					border = "rounded",
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			format_after_save = {
				async = true,
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				javascript = { "prettier", "biome", stop_after_first = true },
				typescript = { "prettier", "biome", stop_after_first = true },
				typescriptreact = { "prettier", "biome", stop_after_first = true },
				lua = { "stylua" },
				go = { "goimports" },
			},
		},
	},
}
