local status_ok, illuminate = pcall(require, "illuminate")
if not status_ok then
  return
end

-- Configure vim-illuminate
illuminate.configure({
  -- Providers: priority order (1-3), LSP is best, Treesitter is second, regex is fallback
  providers = {
    'lsp',
    'treesitter',
    'regex',
  },
  
  -- Delay in milliseconds before highlighting
  delay = 100,
  
  -- File types to disable illuminate
  filetypes_denylist = {
    'dirbuf',
    'dirvish',
    'fugitive',
    'alpha',
    'NvimTree',
    'lazy',
    'neogitstatus',
    'Trouble',
    'lir',
    'Outline',
    'spectre_panel',
    'toggleterm',
    'DressingSelect',
    'TelescopePrompt',
    'help',
    'man',
    'qf',
    'lspinfo',
    'mason',
  },
  
  -- File types to enable illuminate (overrides denylist)
  filetypes_allowlist = {},
  
  -- Modes to enable illuminate
  modes_denylist = {},
  modes_allowlist = {},
  
  -- Providers to use for different buffer types
  providers_regex_syntax_denylist = {},
  providers_regex_syntax_allowlist = {},
  
  -- Enable/disable under cursor highlighting
  under_cursor = true,
  
  -- Enable/disable large file detection
  large_file_cutoff = nil,
  
  -- Minimum number of matches to consider highlighting
  min_count_to_highlight = 1,
  
  -- Should a message be printed when large file detection is triggered
  large_file_overrides = nil,
  
  -- Case sensitive matching
  case_insensitive_regex = false,
})

-- Set up keymaps for navigation
local opts = { noremap = true, silent = true }

-- Navigate to next/previous illuminated reference
vim.keymap.set("n", "<A-n>", function()
  require("illuminate").goto_next_reference(false)
end, { desc = "Move to next reference" })

vim.keymap.set("n", "<A-p>", function()
  require("illuminate").goto_prev_reference(false)
end, { desc = "Move to previous reference" })

-- Alternative keymaps using ]r and [r 
vim.keymap.set("n", "]r", function()
  require("illuminate").goto_next_reference(false)
end, { desc = "Move to next reference" })

vim.keymap.set("n", "[r", function()
  require("illuminate").goto_prev_reference(false)
end, { desc = "Move to previous reference" })

-- Set illuminate highlighting color
vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#393552" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#393552" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#393552" })