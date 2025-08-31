local null_ls_status_ok, null_ls = pcall(require, "none-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		-- Core formatters that are most likely to work
		formatting.prettier.with({ 
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      filetypes = { 
        "javascript", "javascriptreact", "typescript", "typescriptreact", 
        "vue", "css", "scss", "less", "html", "json", "jsonc", "yaml", 
        "markdown", "graphql" 
      }
    }),
    
		-- Python formatters and import organizer
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.isort.with({ 
      extra_args = { "--profile", "black" },
      filetypes = { "python" }
    }),
		
		-- Lua formatter
		formatting.stylua,
	},
	-- Configure format on save
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ 
            bufnr = bufnr,
            filter = function(c)
              return c.name == "none-ls"
            end
          })
				end,
			})
		end
	end,
})
