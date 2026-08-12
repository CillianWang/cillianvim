-- Native Codex chat in a right-side floating window.
-- Visual <leader>cs opens a new chat with the selection as context.

local MODEL = "gpt-5.6-luna"
local CODEX_ACP = "@agentclientprotocol/codex-acp@1.1.14"
local CODECOMPANION_CODEX_HOME = vim.fn.stdpath("data") .. "/codecompanion/codex"
local CHINESE_INSTRUCTIONS = table.concat({
  "所有面向用户的自然语言回答必须使用简体中文。",
  "不要切换到其他语言。代码、命令、路径、标识符和必须保留原文的引用除外。",
})
local CHAT_WINHIGHLIGHT = table.concat({
  "Normal:CodeCompanionChatNormal",
  "NormalNC:CodeCompanionChatNormal",
  "NormalFloat:CodeCompanionChatNormal",
  "EndOfBuffer:CodeCompanionChatNormal",
  "SignColumn:CodeCompanionChatNormal",
  "LineNr:CodeCompanionChatLineNr",
  "CursorLineNr:CodeCompanionChatCursorLineNr",
  "CursorLine:CodeCompanionChatCursorLine",
  "FoldColumn:CodeCompanionChatNormal",
  "FloatBorder:CodeCompanionChatBorder",
  "FloatTitle:CodeCompanionChatTitle",
}, ",")
local LEGACY_ANSWER_BACKGROUND_NS = vim.api.nvim_create_namespace("CodeCompanionAnswerBackground")
local QUESTION_TEXT_NS = vim.api.nvim_create_namespace("CodeCompanionQuestionText")

local loading_spinners = {}
local pending_acp_submits = {}

local function stop_loading(bufnr)
  local spinner = bufnr and loading_spinners[bufnr]
  if spinner then
    spinner:stop()
    loading_spinners[bufnr] = nil
  end
end

local function start_loading(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  stop_loading(bufnr)

  local ok, Spinner = pcall(require, "snacks.picker.util.spinner")
  if not ok then
    return
  end

  loading_spinners[bufnr] = Spinner.new(bufnr, {
    extmark = function(frame)
      return {
        virt_lines = {
          { { "  " .. frame .. "  Codex 正在生成完整回答…", "CodeCompanionLoading" } },
        },
      }
    end,
  })
end

-- CodeCompanion starts an ACP connection asynchronously as soon as a chat is
-- created. If the user submits before initialize finishes, its handler starts
-- the same Connection again; the second process overwrites the first handle
-- and Codex rejects authenticate/session-new with `Not initialized`.
-- Defer that first submission until the maintained ACPConnected event instead.
local function guard_acp_startup(chat)
  if not chat or chat._codex_acp_startup_guard then
    return
  end
  chat._codex_acp_startup_guard = true
  chat:add_callback("on_before_submit", function(current)
    if current.adapter.name ~= "codex" then
      return
    end
    local connection = current.acp_connection
    local initializing = connection == nil
      or (connection._state and connection._state.handle and not connection:is_ready())
    if initializing then
      if not pending_acp_submits[current.bufnr] then
        pending_acp_submits[current.bufnr] = true
        start_loading(current.bufnr)
        vim.defer_fn(function()
          if pending_acp_submits[current.bufnr] then
            pending_acp_submits[current.bufnr] = nil
            stop_loading(current.bufnr)
            vim.notify("Codex ACP 初始化超时，请再次发送", vim.log.levels.WARN)
          end
        end, 125000)
      end
      return false
    end
  end)
end

-- ACP responses arrive as chunks. Buffer Codex's chunks inside the maintained
-- CodeCompanion handler and add them to the chat once, when the turn finishes.
-- Other ACP adapters retain their normal streaming behavior.
local function install_atomic_acp_output()
  local ok, Handler = pcall(require, "codecompanion.interactions.chat.acp.handler")
  if not ok or Handler._codex_atomic_output then
    return
  end

  local original_message_chunk = Handler.handle_message_chunk
  local original_thought_chunk = Handler.handle_thought_chunk
  local original_complete = Handler.handle_complete
  local original_error = Handler.handle_error

  Handler.handle_message_chunk = function(self, content)
    if self.chat.adapter.name ~= "codex" then
      return original_message_chunk(self, content)
    end
    table.insert(self.output, content)
  end

  Handler.handle_thought_chunk = function(self, content)
    if self.chat.adapter.name ~= "codex" then
      return original_thought_chunk(self, content)
    end
    table.insert(self.reasoning, content)
  end

  Handler.handle_complete = function(self)
    if self.chat.adapter.name == "codex" then
      stop_loading(self.chat.bufnr)
      local config = require("codecompanion.config")
      local reasoning = table.concat(self.reasoning, "")
      local output = table.concat(self.output, "")

      if config.display.chat.show_reasoning and reasoning ~= "" then
        self.chat:add_buf_message(
          { role = config.constants.LLM_ROLE, content = reasoning },
          { type = self.chat.MESSAGE_TYPES.REASONING_MESSAGE }
        )
      end
      if output ~= "" then
        self.chat:add_buf_message(
          { role = config.constants.LLM_ROLE, content = output },
          { type = self.chat.MESSAGE_TYPES.LLM_MESSAGE }
        )
      end
    end
    return original_complete(self)
  end

  Handler.handle_error = function(self, error)
    if self.chat.adapter.name == "codex" then
      stop_loading(self.chat.bufnr)
    end
    return original_error(self, error)
  end

  Handler._codex_atomic_output = true
end

local function set_chat_highlights()
  -- TokyoNight Storm palette, scoped to the CodeCompanion floating window.
  vim.api.nvim_set_hl(0, "CodeCompanionChatNormal", { fg = "#c0caf5", bg = "#24283b" })
  vim.api.nvim_set_hl(0, "CodeCompanionQuestionText", { fg = "#e0af68" })
  vim.api.nvim_set_hl(0, "CodeCompanionChatBorder", { fg = "#9d7cd8", bg = "#24283b" })
  vim.api.nvim_set_hl(0, "CodeCompanionChatTitle", { fg = "#bb9af7", bg = "#24283b", bold = true })
  vim.api.nvim_set_hl(0, "CodeCompanionChatLineNr", { fg = "#565f89", bg = "#24283b" })
  vim.api.nvim_set_hl(0, "CodeCompanionChatCursorLineNr", { fg = "#bb9af7", bg = "#292e49", bold = true })
  vim.api.nvim_set_hl(0, "CodeCompanionChatCursorLine", { bg = "#292e49" })
  vim.api.nvim_set_hl(0, "CodeCompanionMarkdownHeading", { fg = "#bb9af7", bg = "#292e49", bold = true })
  -- Code blocks use TokyoNight's darker surface so they remain visibly
  -- distinct from the Storm chat background.
  vim.api.nvim_set_hl(0, "CodeCompanionMarkdownCode", { fg = "#c0caf5", bg = "#1f2335" })
  vim.api.nvim_set_hl(0, "CodeCompanionMarkdownCodeInfo", { fg = "#7dcfff", bg = "#1f2335", bold = true })
  vim.api.nvim_set_hl(0, "CodeCompanionMarkdownCodeBorder", { fg = "#9d7cd8", bg = "#1f2335" })
  vim.api.nvim_set_hl(0, "CodeCompanionMarkdownInlineCode", { fg = "#7dcfff", bg = "#292e49" })
  vim.api.nvim_set_hl(0, "CodeCompanionLoading", { fg = "#bb9af7", bg = "#24283b", bold = true })
end

local function apply_question_text(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, QUESTION_TEXT_NS, 0, -1)
  local in_question = false
  for row, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    if line:match("^##%s+问题%s*$") then
      in_question = true
    elseif line:match("^##%s+Codex%s*$") then
      in_question = false
    end

    if in_question then
      vim.api.nvim_buf_set_extmark(bufnr, QUESTION_TEXT_NS, row - 1, 0, {
        end_row = row,
        end_col = 0,
        hl_group = "CodeCompanionQuestionText",
        hl_mode = "combine",
        -- Markdown headings, inline code, and fenced code use higher-priority
        -- renderer highlights; ordinary question prose keeps this gold color.
        priority = 10,
      })
    end
  end
end

local function apply_chat_window(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    if vim.api.nvim_win_is_valid(win) then
      vim.wo[win].winhighlight = CHAT_WINHIGHLIGHT
      vim.wo[win].winblend = 0
    end
  end
end

local function render_chat_markdown(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local ok, markdown = pcall(require, "render-markdown")
  if ok then
    markdown.render({
      buf = bufnr,
      win = vim.fn.win_findbuf(bufnr),
      event = "CodeCompanionChat",
    })
  end
  -- Clear answer-only backgrounds from older loaded versions of this config;
  -- questions and answers now share CodeCompanionChatNormal.
  vim.api.nvim_buf_clear_namespace(bufnr, LEGACY_ANSWER_BACKGROUND_NS, 0, -1)
  apply_question_text(bufnr)
end

-- CodeCompanion inserts a visual selection inside a four-backtick fenced
-- block. Keep the prompt on the next line and repair the common malformed form
-- produced when typing begins inside that closing fence:
--     ```question`  ->  ```` + newline + question
local function separate_prompt_from_fence(bufnr, move_cursor)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local opening
  for index, line in ipairs(lines) do
    if not opening then
      opening = line:match("^(```+)%S")
    else
      local trailing
      if vim.startswith(line, opening) then
        trailing = line:sub(#opening + 1)
      else
        -- The closing four ticks can be split around the typed question as
        -- three leading ticks and one trailing tick.
        local leading, middle, ending = line:match("^(```+)(.-)(`+)$")
        if leading and #leading >= 3 and #leading + #ending == #opening and middle ~= "" then
          trailing = middle
        end
      end

      if trailing == nil then
        goto continue
      end

      local cursor_line

      if trailing ~= "" then
        vim.api.nvim_buf_set_lines(bufnr, index - 1, index, false, { opening, trailing })
        cursor_line = index + 1
      else
        if index == #lines then
          vim.api.nvim_buf_set_lines(bufnr, index, index, false, { "" })
        end
        cursor_line = index + 1
      end

      if move_cursor and cursor_line then
        local wins = vim.fn.win_findbuf(bufnr)
        local win = wins[1]
        if win and vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_set_cursor(win, { cursor_line, 0 })
          if vim.api.nvim_get_current_win() == win then
            vim.cmd("startinsert")
          end
        end
      end
      return
    end
    ::continue::
  end

  -- A normal-mode new chat has no selection fence. Preserve the usual UX by
  -- placing the cursor at the end and entering Insert mode there.
  if move_cursor then
    local win = vim.fn.win_findbuf(bufnr)[1]
    if win and vim.api.nvim_win_is_valid(win) then
      local last = math.max(1, vim.api.nvim_buf_line_count(bufnr))
      local text = vim.api.nvim_buf_get_lines(bufnr, last - 1, last, false)[1] or ""
      vim.api.nvim_win_set_cursor(win, { last, #text })
      if vim.api.nvim_get_current_win() == win then
        vim.cmd("startinsert")
      end
    end
  end
end

local function executable(name, fallback)
  local resolved = vim.fn.exepath(name)
  return resolved ~= "" and resolved or fallback
end

local function chat_window()
  local columns = vim.o.columns
  local rows = vim.o.lines - vim.o.cmdheight
  local horizontal_margin = math.max(2, math.floor(columns * 0.02))
  local vertical_margin = math.max(1, math.floor(rows * 0.04))
  local col = math.floor(columns / 2) + horizontal_margin
  local width = math.max(20, columns - col - horizontal_margin - 2)
  local height = math.max(8, rows - (vertical_margin * 2) - 2)

  return {
    layout = "float",
    relative = "editor",
    width = width,
    height = height,
    row = vertical_margin,
    col = col,
    border = "rounded",
    title = "",
    opts = {
      breakindent = true,
      linebreak = true,
      wrap = true,
      winhighlight = CHAT_WINHIGHLIGHT,
    },
  }
end

local function selection_origin(context)
  local path = context.path
  if not path or path == "" then
    path = string.format("[未保存的缓冲区 %d]", context.bufnr)
  else
    path = vim.fs.normalize(path)
  end

  local location
  if context.start_line == context.end_line then
    location = string.format("第 %d 行", context.start_line)
  else
    location = string.format("第 %d–%d 行", context.start_line, context.end_line)
  end
  return string.format("> 选中代码来源：`%s`，%s", path, location)
end

local function add_selection_origin(bufnr, context)
  if not context or not context.is_visual or not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local origin = selection_origin(context)

  -- CodeCompanion's maintained visual-context insertion creates the fenced
  -- block. Prefix it with source metadata so both the user and ACP/Codex know
  -- exactly which live buffer and line range the excerpt came from.
  for row, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    if line:match("^````+%S") then
      vim.api.nvim_buf_set_lines(bufnr, row - 1, row - 1, false, { origin, "" })
      return
    end
  end
end

local function new_chat(source_context)
  -- Capture the source before CodeCompanion focuses its chat window. Passing
  -- it explicitly also prevents later window changes from replacing the
  -- selection's buffer context.
  source_context = source_context
    or require("codecompanion.utils.context").get(vim.api.nvim_get_current_buf())
  local chat = require("codecompanion").chat({
    callbacks = {
      on_created = guard_acp_startup,
    },
    context = source_context,
    window_opts = chat_window(),
  })
  -- Run once synchronously, before the user can type into the closing fence.
  if chat then
    add_selection_origin(chat.bufnr, source_context)
    separate_prompt_from_fence(chat.bufnr, true)
  end
  vim.schedule(function()
    if chat then
      -- Keep a scheduled pass as CodeCompanion can finish inserting visual
      -- context on the next event-loop tick.
      separate_prompt_from_fence(chat.bufnr, true)
      render_chat_markdown(chat.bufnr)
    end
  end)
  return chat
end

-- CodeCompanion's maintained `CodeCompanionChat Add` workflow keeps one ACP
-- chat alive and appends later visual selections to it. Preserve our richer
-- path/line metadata while using the same public chat API, so <leader>cs pays
-- initialize/authenticate only for the first chat instead of for every query.
local function chat_about_selection()
  local source_context = require("codecompanion.utils.context").get(vim.api.nvim_get_current_buf())
  local chat = require("codecompanion.interactions.chat").last_chat()

  if not chat or chat.adapter.name ~= "codex" then
    return new_chat(source_context)
  end

  local content = string.format(
    "%s\n\n````%s\n%s\n````",
    selection_origin(source_context),
    source_context.filetype or "",
    table.concat(source_context.lines or {}, "\n")
  )
  chat:add_buf_message({
    role = require("codecompanion.config").constants.USER_ROLE,
    content = content,
  })

  require("codecompanion").restore(chat.bufnr)
  apply_chat_window(chat.bufnr)
  render_chat_markdown(chat.bufnr)

  -- Keep input safely below the closing fence. Enter submits from Insert mode.
  local last = vim.api.nvim_buf_line_count(chat.bufnr)
  local text = vim.api.nvim_buf_get_lines(chat.bufnr, last - 1, last, false)[1] or ""
  if text ~= "" then
    vim.api.nvim_buf_set_lines(chat.bufnr, last, last, false, { "" })
    last = last + 1
  end
  local win = vim.fn.win_findbuf(chat.bufnr)[1]
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    vim.api.nvim_win_set_cursor(win, { last, 0 })
    vim.cmd("startinsert")
  end
  return chat
end

local function toggle_chat()
  require("codecompanion").toggle_chat({ window_opts = chat_window() })
end

return {
  "olimorris/codecompanion.nvim",
  version = "^19",
  init = function()
    set_chat_highlights()
    local group = vim.api.nvim_create_augroup("CodeCompanionTokyoNight", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = function()
        set_chat_highlights()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[bufnr].filetype == "codecompanion" then
            apply_chat_window(bufnr)
          end
        end
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "codecompanion",
      callback = function(args)
        vim.schedule(function()
          install_atomic_acp_output()
          apply_chat_window(args.buf)
          render_chat_markdown(args.buf)
        end)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "CodeCompanionChatSubmitted",
      callback = function(args)
        start_loading(args.data and args.data.bufnr)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "CodeCompanionACPConnected",
      callback = function(args)
        local bufnr = args.data and args.data.bufnr
        if not pending_acp_submits[bufnr] then
          return
        end
        pending_acp_submits[bufnr] = nil
        vim.schedule(function()
          local chat = require("codecompanion.interactions.chat").buf_get_chat(bufnr)
          if chat and not chat.current_request then
            chat:submit()
          end
        end)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = {
        "CodeCompanionChatDone",
        "CodeCompanionChatStopped",
        "CodeCompanionChatRestored",
        "CodeCompanionChatClosed",
      },
      callback = function(args)
        local bufnr = args.data and args.data.bufnr
        if args.match ~= "CodeCompanionChatRestored" or not pending_acp_submits[bufnr] then
          pending_acp_submits[bufnr] = nil
          stop_loading(bufnr)
        end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = { "CodeCompanionChatCreated", "CodeCompanionChatOpened", "CodeCompanionChatDone" },
      callback = function(args)
        local bufnr = args.data and args.data.bufnr
        vim.schedule(function()
          install_atomic_acp_output()
          guard_acp_startup(require("codecompanion.interactions.chat").buf_get_chat(bufnr))
          separate_prompt_from_fence(bufnr, false)
          apply_chat_window(bufnr)
          render_chat_markdown(bufnr)
        end)
      end,
    })
    vim.api.nvim_create_autocmd("VimResized", {
      group = group,
      callback = function()
        local window = chat_window()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[bufnr].filetype == "codecompanion" then
            for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
              if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_set_config(win, {
                  relative = window.relative,
                  width = window.width,
                  height = window.height,
                  row = window.row,
                  col = window.col,
                  border = window.border,
                  title = "",
                })
              end
            end
          end
        end
      end,
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "folke/snacks.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      lazy = false,
    },
  },
  opts = {
    adapters = {
      acp = {
        codex = function()
          local adapter = require("codecompanion.adapters").extend("codex", {
            commands = {
              default = {
                executable("npx", "/Users/pingy/.local/bin/npx"),
                "-y",
                CODEX_ACP,
              },
            },
            defaults = {
              auth_method = "chat-gpt",
              -- ChatGPT session renewal may open a browser. CodeCompanion's
              -- 20-second ACP default can expire before that flow completes,
              -- leaving a misleading `auth failed`; keep the async request
              -- alive long enough for a normal browser round trip.
              timeout = 120000,
              session_config_options = {
                model = MODEL,
                mode = "read-only",
                thought_level = "low",
                model_config = "on",
              },
            },
            env = {
              -- Isolate Neovim sessions from ~/.codex so the desktop app does
              -- not index them as Codex tasks.
              CODEX_HOME = CODECOMPANION_CODEX_HOME,
              CODEX_CONFIG = function()
                return vim.json.encode({
                  developer_instructions = CHINESE_INSTRUCTIONS,
                })
              end,
              -- Let codex-acp repeat ChatGPT authentication if session/new
              -- discovers that the shared Codex session needs renewal.
              DEFAULT_AUTH_REQUEST = vim.json.encode({ methodId = "chat-gpt" }),
              INITIAL_AGENT_MODE = "read-only",
            },
          })

          -- codex-acp ships a compatible Codex CLI. The isolated home reuses
          -- the existing ChatGPT login through an auth.json symlink.
          -- The stock CodeCompanion adapter maps an absent API key to the
          -- literal string "OPENAI_API_KEY", which interferes with ChatGPT
          -- authentication, so remove that inherited environment entry.
          adapter.env.OPENAI_API_KEY = nil
          return adapter
        end,
      },
    },
    interactions = {
      chat = {
        adapter = {
          name = "codex",
          model = MODEL,
        },
        keymaps = {
          send = {
            modes = {
              n = "<CR>",
              i = "<CR>",
            },
            index = 2,
            callback = "keymaps.send",
            description = "Send the message to Codex",
          },
        },
        roles = {
          user = "问题",
          llm = function()
            return "Codex"
          end,
        },
      },
    },
    display = {
      chat = {
        intro_message = "",
        fold_context = true,
        show_context = true,
        fold_reasoning = true,
        show_reasoning = true,
        show_header_separator = false,
        -- new_chat() moves to a safe prompt line and enters insert mode only
        -- after repairing the visual-selection fence.
        start_in_insert_mode = false,
        window = chat_window(),
      },
    },
    opts = {
      language = "Chinese",
      log_level = "ERROR",
    },
  },
  keys = {
    {
      "<leader>cc",
      toggle_chat,
      desc = "Toggle Codex chat",
      mode = "n",
    },
    {
      "<leader>cs",
      chat_about_selection,
      desc = "Add selection to the current Codex chat",
      mode = "x",
    },
    {
      "<leader>cC",
      new_chat,
      desc = "New Codex chat",
      mode = "n",
    },
  },
}
