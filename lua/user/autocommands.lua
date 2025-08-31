local api = vim.api

local function AUG(name)
  if not name:match("^[%w_]+$") then
    error("Invalid augroup name detected in autocommands.lua: '" .. name .. "' - contains invalid characters")
  end
  return api.nvim_create_augroup(name, { clear = true })
end

-- General settings
local general_group = AUG("_general_settings")

api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "help", "man", "lspinfo" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
  end,
  group = general_group,
})

api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({higroup = 'Visual', timeout = 200})
  end,
  group = general_group,
})

api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  group = general_group,
})

api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
  group = general_group,
})

-- Git
local git_group = AUG("_git")

api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  group = git_group,
})

-- Markdown
local markdown_group = AUG("_markdown")

api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  group = markdown_group,
})

-- Auto resize
local resize_group = AUG("_auto_resize")

api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  group = resize_group,
})

-- Alpha
local alpha_group = AUG("_alpha")

api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    vim.opt.showtabline = 0
  end,
  group = alpha_group,
})

api.nvim_create_autocmd("BufUnload", {
  callback = function()
    vim.opt.showtabline = 2
  end,
  group = alpha_group,
})

-- Autoformat
-- augroup _lsp
--   autocmd!
--   autocmd BufWritePre * lua vim.lsp.buf.formatting()
-- augroup end
