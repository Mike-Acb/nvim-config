local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

-- Disable problematic parsers that might cause query errors
local problematic_langs = { "phpdoc", "comment" }

configs.setup({
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to install (more conservative list)
  ensure_installed = {
    "bash", "c", "css", "go", "html", "java", "javascript",
    "json", "lua", "markdown", "python", "rust",
    "sql", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml"
  },

  -- List of parsers to ignore installing (or "all")
  ignore_install = problematic_langs,

  -- Highlight configuration
  highlight = {
    enable = true,
    -- Disable highlighting for problematic languages and large files
    disable = function(lang, buf)
      -- Disable for problematic languages
      if vim.tbl_contains(problematic_langs, lang) then
        return true
      end
        -- Disable for tsx files due to known issues
      --if lang == "tsx" then return true end

      -- Disable for large files
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end

      return false
    end,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    additional_vim_regex_highlighting = false,
  },

  -- Indentation based on treesitter
  indent = {
    enable = true,
    disable = { "python", "yaml", "css" } -- These languages have better vim indentation
  },

  -- Incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

  -- Text objects
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },

  -- Auto tag (for HTML/JSX)
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
  },
})

-- Setup treesitter context with error handling
local context_status_ok, treesitter_context = pcall(require, "treesitter-context")
if context_status_ok then
  treesitter_context.setup({
    enable = true,
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    separator = nil,
    zindex = 20, -- The Z-index of the context window
    on_attach = function(buf)
      -- Disable context for certain filetypes
      local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
      if vim.tbl_contains({ "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" }, filetype) then
        return false
      end
      return true
    end,
  })
end

-- Setup autotag if available
local autotag_ok, autotag = pcall(require, "nvim-ts-autotag")
if autotag_ok then
  autotag.setup({
    opts = {
      -- Defaults
      enable_close = true, -- Auto close tags
      enable_rename = true, -- Auto rename pairs of tags
      enable_close_on_slash = false -- Auto close on trailing </
    },
  })
end
