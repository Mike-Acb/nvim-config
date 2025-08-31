local status_ok, icons = pcall(require, "nvim-web-devicons")
if not status_ok then
  return
end

-- 设置图标
icons.setup {
  -- 全局启用图标（默认为 true）
  default = true,
  
  -- 严格模式：只显示已定义的图标（默认为 false）
  strict = false,
  
  -- 覆盖默认图标
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
    }
  },
  
  -- 按文件扩展名覆盖
  override_by_filename = {
    [".gitignore"] = {
      icon = "",
      color = "#f1502f",
      name = "Gitignore"
    }
  },
  
  -- 按扩展名覆盖
  override_by_extension = {
    ["log"] = {
      icon = "",
      color = "#81e043",
      name = "Log"
    }
  },
  
  -- 颜色图标（需要 termguicolors）
  color_icons = true,
}

-- 确保 termguicolors 启用
vim.opt.termguicolors = true