local M = {}
local dap = require("dap")

-- PRIVATE API
--
local function get_visual_selection()
  -- TODo: fix deprecation warning by removing unpack
	local _, line_start, col_start = unpack(vim.fn.getpos("v"))
	local _, line_end, col_end = unpack(vim.fn.getpos("."))
	local selection = vim.api.nvim_buf_get_text(0, line_start - 1, col_start - 1, line_end - 1, col_end, {})
	return selection
end

local function setup_visidata()
	dap.repl.execute("import visidata; visidata.options.theme = 'asciimono'")
end

local function print_object(python_object)
  dap.repl.execute("print(" .. python_object .. ")")
end


-- PUBLIC API
M.show_dataframe_as_table = function()
  -- set the default theme to work show better colors
  setup_visidata()
	local selected_dataframe = get_visual_selection()[1]
	dap.repl.execute("visidata.vd.view_pandas(" .. selected_dataframe .. ")")
end


M.print_dataframe = function()
  local selected_dataframe = get_visual_selection()[1]
  print_object(selected_dataframe)
end

M.print_dataframe_columns = function()
  local selected_dataframe = get_visual_selection()[1]
  print_object(selected_dataframe .. ".columns")
end


local function set_keymaps()
  vim.keymap.set("v", "<leader>vt", M.show_dataframe_as_table, { desc = "[v]isualize [t]able" })
  vim.keymap.set("v", "<leader>vp", M.print_dataframe, { desc = "[v]isualize [p]rinted dataframe" })
  vim.keymap.set("v", "<leader>vc", M.print_dataframe_columns, { desc = "[v]isualize [c]olumns" })
end

function M.setup(opts)
  -- TODO: allow using options
  opts = opts or {}

  -- TODO: when visualize_pandas_df is called, make sure the previous view/table is closed (not crucial)
  -- TODO: load this plugin only when the debugger is started (perhaps even listeners?)
  -- TODO: add event listener when debugger is started to run ``setup_visidata``
  -- TODO: check if the keymap is already set
  -- TODO: allow custom keymaps using `keys`
  set_keymaps()
end
return M
