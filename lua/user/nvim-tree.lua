local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

-- 禁用 netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 设置 termguicolors
vim.opt.termguicolors = true

-- 确保图标字体正确加载
if vim.fn.has('nvim-0.8') == 1 then
  -- 新版本 nvim-tree 不需要手动定义诊断 sign
  -- 它们会自动处理
else
  -- 为旧版本定义 sign
  vim.fn.sign_define('NvimTreeDiagnosticErrorIcon', { text = '', texthl = 'DiagnosticSignError' })
  vim.fn.sign_define('NvimTreeDiagnosticWarnIcon',  { text = '', texthl = 'DiagnosticSignWarn'  })
  vim.fn.sign_define('NvimTreeDiagnosticInfoIcon',  { text = '', texthl = 'DiagnosticSignInfo'  })
  vim.fn.sign_define('NvimTreeDiagnosticHintIcon',  { text = '', texthl = 'DiagnosticSignHint'  })
end

nvim_tree.setup {
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    root_folder_label = false,
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      -- 使用 nvim-web-devicons 的默认图标
      -- glyphs 配置已移除，让插件自动处理图标
    },
  },
  diagnostics = {
    enable = false,
    show_on_dirs = true,
    debounce_delay = 50,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  view = {
    width = 30,
    side = "left",
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    
    -- 默认映射
    api.config.mappings.default_on_attach(bufnr)
    
    -- 自定义映射
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
    vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
  end,
}