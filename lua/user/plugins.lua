local fn = vim.fn

local function AUG(name)
  if not name:match("^[%w_]+$") then
    error("Invalid augroup name detected in plugins.lua: '" .. name .. "' - contains invalid characters")
  end
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
local packer_group = AUG('packer_user_config')
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'plugins.lua',
  command = 'source <afile> | PackerSync',
  group = packer_group,
})

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
  use { "wbthomason/packer.nvim" } -- Packer 自身管理
  use { "nvim-lua/plenary.nvim" } -- Lua 工具库
  use { "windwp/nvim-autopairs" } -- 自动闭合括号
  use { "numToStr/Comment.nvim" } -- 注释插件
  use { "JoosepAlviste/nvim-ts-context-commentstring" } -- 上下文注释
  use { "nvim-tree/nvim-web-devicons" } -- 图标插件 (项目已迁移)
  use { "nvim-tree/nvim-tree.lua" } -- 文件树插件 (项目已迁移)
  use { "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" } -- 标签页/缓冲区线
	use { "moll/vim-bbye" } -- 缓冲区删除
  use { "nvim-lualine/lualine.nvim" } -- 状态栏
  use { "akinsho/toggleterm.nvim", tag = "*"} -- 终端管理
  use { "ahmedkhalf/project.nvim" } -- 项目管理
  use { "lewis6991/impatient.nvim" } -- 加速启动
  use { "lukas-reineke/indent-blankline.nvim", tag = "v2.20.8" } -- 缩进线
  use { "goolord/alpha-nvim" } -- 启动界面
	use {"folke/which-key.nvim", commit = "4433e5ec9a507e5097571ed55c02ea9658fb268a"} -- Use specific commit that fixes E5248
  use {"echasnovski/mini.nvim" }

	-- Colorschemes
  use { "folke/tokyonight.nvim" } -- Tokyo Night 主题
  use { "lunarvim/darkplus.nvim" } -- Dark Plus 主题

	-- Cmp (补全插件 - 最新版本)
  use { "hrsh7th/nvim-cmp" } -- 主补全引擎
  use { "hrsh7th/cmp-buffer" } -- buffer 补全源
  use { "hrsh7th/cmp-path" } -- 文件路径补全
	use { "saadparwaiz1/cmp_luasnip" } -- snippet 补全集成
	use { "hrsh7th/cmp-nvim-lsp" } -- LSP 补全源
	use { "hrsh7th/cmp-nvim-lua" } -- Neovim Lua API 补全
	use { "hrsh7th/cmp-cmdline" } -- 命令行补全 (新增)
	use { "hrsh7th/cmp-calc" } -- 数学计算补全 (新增，可选)
	use { "hrsh7th/cmp-emoji" } -- Emoji 补全 (新增，可选)

	-- Snippets (代码片段)
  use { "L3MON4D3/LuaSnip", tag = "*" } -- snippet 引擎 (使用最新稳定版)
  use { "rafamadriz/friendly-snippets" } -- 常用代码片段集合

	-- LSP
	use { "neovim/nvim-lspconfig" } -- enable LSP
  use { "williamboman/mason.nvim" } -- simple to use language server installer
  use { "williamboman/mason-lspconfig.nvim" }
  use { "jay-babu/mason-null-ls.nvim" } -- mason 与 null-ls 桥接 (维护者已更改)
	use { "nvimtools/none-ls.nvim" } -- for formatters and linters (maintained fork of null-ls)
	use { "RRethy/vim-illuminate" }

	-- Telescope (模糊查找)
	use { "nvim-telescope/telescope.nvim", tag = '0.1.x'}

	-- Treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
	}
	use "nvim-treesitter/nvim-treesitter-textobjects"  -- Additional text objects
	use "nvim-treesitter/nvim-treesitter-context"      -- Show context
	use "windwp/nvim-ts-autotag"                       -- Auto close and rename HTML tags

	-- Git
	use { "lewis6991/gitsigns.nvim" } -- Git 标记
  -- draucula 🧛
  use { 'Mofiqul/dracula.nvim'}

    -- avante start
    -- Required plugins (avoiding duplicates)
    use 'MunifTanjim/nui.nvim'
    use 'MeanderingProgrammer/render-markdown.nvim'

    -- Optional dependencies (avoiding duplicates)
    use 'HakonHarnes/img-clip.nvim'
    use 'zbirenbaum/copilot.lua'
    use 'stevearc/dressing.nvim' -- for enhanced input UI
    use 'folke/snacks.nvim' -- for modern input UI
    use {
      'yetone/avante.nvim',
      branch = 'main',
      run = 'make',
      config = function()
        require('avante').setup()
      end
    }
    -- avante end

  -- java (temporarily disabled due to E5248 error)
  -- use { 'mfussenegger/nvim-jdtls' }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
