local M = {}

local modes = {
  { id = "n", name = "Normal" },
  { id = "i", name = "Insert" },
  { id = "v", name = "Visual + Select" },
  { id = "x", name = "Visual" },
  { id = "s", name = "Select" },
  { id = "o", name = "Operator-pending" },
  { id = "c", name = "Command-line" },
  { id = "t", name = "Terminal" },
}

local function replace_special_keys(lhs)
  local leader = vim.g.mapleader or "\\"
  local localleader = vim.g.maplocalleader or "\\"

  if leader ~= "" then
    lhs = lhs:gsub(vim.pesc(leader), "<Leader>")
  end
  if localleader ~= "" and localleader ~= leader then
    lhs = lhs:gsub(vim.pesc(localleader), "<LocalLeader>")
  end
  lhs = lhs:gsub(" ", "<Space>")
  return lhs
end

local function clean(text)
  return (text or ""):gsub("[\r\n]+", " "):gsub("|", "\\|")
end

local function fallback_description(mapping)
  if mapping.callback then
    return "Lua callback"
  end

  local rhs = clean(mapping.rhs)
  if rhs == "" or rhs == "<Nop>" then
    return rhs == "<Nop>" and "Disabled" or "(no description)"
  end
  return "`" .. rhs .. "`"
end

local function collect(mode)
  local by_lhs = {}

  for _, mapping in ipairs(vim.api.nvim_get_keymap(mode)) do
    mapping.scope = "global"
    by_lhs[mapping.lhs] = mapping
  end
  for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
    mapping.scope = "buffer"
    by_lhs[mapping.lhs] = mapping
  end

  local mappings = vim.tbl_values(by_lhs)
  table.sort(mappings, function(a, b)
    return a.lhs:lower() < b.lhs:lower()
  end)
  return mappings
end

local function markdown()
  local lines = {
    "# Neovim Keymap Help",
    "",
    "> Generated from the keymaps active in the current buffer.",
    "> Press `q` or `Esc` to close; use `/` to search.",
    "",
  }

  for _, mode in ipairs(modes) do
    local mappings = collect(mode.id)
    if #mappings > 0 then
      vim.list_extend(lines, {
        "## " .. mode.name .. " (`" .. mode.id .. "`)",
        "",
        "| Key | Description | Scope |",
        "| --- | --- | --- |",
      })

      for _, mapping in ipairs(mappings) do
        local lhs = clean(replace_special_keys(mapping.lhs))
        local description = clean(mapping.desc)
        if description == "" then
          description = fallback_description(mapping)
        end
        lines[#lines + 1] = ("| `%s` | %s | %s |"):format(lhs, description, mapping.scope)
      end
      lines[#lines + 1] = ""
    end
  end

  return lines
end

function M.open()
  local current = vim.api.nvim_get_current_win()
  local width = math.min(110, math.max(60, vim.o.columns - 8))
  local height = math.min(math.max(18, vim.o.lines - 8), 42)
  local buffer = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_name(buffer, "keymap-help.md")
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, markdown())
  vim.bo[buffer].buftype = "nofile"
  vim.bo[buffer].bufhidden = "wipe"
  vim.bo[buffer].swapfile = false
  vim.bo[buffer].filetype = "markdown"
  vim.bo[buffer].modifiable = false

  local window = vim.api.nvim_open_win(buffer, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " Neovim Keymaps ",
    title_pos = "center",
  })

  vim.wo[window].conceallevel = 2
  vim.wo[window].cursorline = true
  vim.wo[window].foldenable = false
  vim.wo[window].linebreak = true
  vim.wo[window].wrap = false

  local close = function()
    if vim.api.nvim_win_is_valid(window) then
      vim.api.nvim_win_close(window, true)
    end
    if vim.api.nvim_win_is_valid(current) then
      vim.api.nvim_set_current_win(current)
    end
  end
  vim.keymap.set("n", "q", close, { buffer = buffer, nowait = true, silent = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buffer, nowait = true, silent = true })
end

vim.api.nvim_create_user_command("KeymapHelp", M.open, {
  desc = "Show all active keymaps in a Markdown popup",
})

return M
