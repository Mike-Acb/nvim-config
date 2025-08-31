-- bufferline 配置
local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

-- 确保图标插件可用
local icons_ok, _ = pcall(require, "nvim-web-devicons")
if not icons_ok then
  vim.notify("nvim-web-devicons not found", vim.log.levels.WARN)
  return
end

bufferline.setup {
  options = {
    -- 图标显示
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    
    -- 鼠标操作
    close_command = "Bdelete! %d",
    right_mouse_command = "Bdelete! %d",
    left_mouse_command = "buffer %d",
    
    -- 外观
    indicator = {
      style = 'icon',
      icon = '▎',
    },
    separator_style = "thin",
    always_show_bufferline = true,
    
    -- nvim-tree 集成
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left"
      }
    },
  }
}
