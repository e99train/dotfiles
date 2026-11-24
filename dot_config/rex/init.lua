-- Rex configuration
-- Loaded by the Rex server from ~/.config/rex/init.lua

-- Last session toggle state
-- Tracks the session the user was in before the current one, so ctrl+space+tab
-- can toggle between the two most recently used sessions (like herdr's
-- last-workspace plugin). A background tracker (track-last-session.lua) updates
-- ~/.local/state/rex/last-session.txt whenever the app focuses a different
-- session, so manual session switches are remembered too.
local last_session_id = nil
local current_session_id = nil
local LAST_SESSION_STATE_FILE = os.getenv("HOME") .. "/.local/state/rex/last-session.txt"
local LAST_SESSION_TRACKER = os.getenv("HOME") .. "/.config/rex/track-last-session.lua"
local LAST_SESSION_TRACKER_PID = os.getenv("HOME") .. "/.local/state/rex/track-last-session.pid"
local REX_BIN = "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex"

local function read_last_session_state()
  local cur, last
  local f = io.open(LAST_SESSION_STATE_FILE, "r")
  if f then
    for line in f:lines() do
      local k, v = line:match("^(%w+)=(.*)$")
      if k == "current" then cur = v end
      if k == "last" then last = v end
    end
    f:close()
  end
  return cur, last
end

local function write_last_session_state(cur, last)
  rex.exec({ "mkdir", "-p", os.getenv("HOME") .. "/.local/state/rex" })
  local f = io.open(LAST_SESSION_STATE_FILE, "w")
  if not f then return end
  if cur and cur ~= "" then f:write("current=" .. cur .. "\n") end
  if last and last ~= "" then f:write("last=" .. last .. "\n") end
  f:close()
end

local function session_exists(id)
  if type(id) ~= "string" or id == "" then return false end
  local res = rex.call("session.list")
  if type(res) == "table" and type(res.sessions) == "table" then
    for _, s in ipairs(res.sessions) do
      if type(s) == "table" and s.session_id == id then
        return true
      end
    end
  end
  return false
end

-- Start the session tracker if it is not already running.
local function tracker_running()
  local f = io.open(LAST_SESSION_TRACKER_PID, "r")
  if not f then return false end
  local pid = f:read("*l")
  f:close()
  if pid == nil or pid == "" then return false end
  local r = rex.exec({ "/bin/kill", "-0", pid })
  return r ~= nil and r.ok
end

if not tracker_running() then
  local h = rex.exec.start({ REX_BIN, "do", LAST_SESSION_TRACKER, "--all" }, {
    detach = true,
    stdout = false,
    stderr = false,
  })
  if h ~= nil and h.pid ~= nil then
    local f = io.open(LAST_SESSION_TRACKER_PID, "w")
    if f then
      f:write(tostring(h.pid) .. "\\n")
      f:close()
    end
  end
end
-- Ghostty "Builtin Dark" palette, with this user's overrides
local GHOSTTY_THEME = {
  foreground = "#bbbbbb",
  background = "#000000",
  cursor = "#98989d",
  scheme = "dark",
  palette = {
    "0=#000000", "1=#bb0000", "2=#00bb00", "3=#bbbb00",
    "4=#0d0dc8", "5=#bb00bb", "6=#00bbbb", "7=#bbbbbb",
    "8=#555555", "9=#ff5555", "10=#55ff55", "11=#ffff55",
    "12=#5555ff", "13=#ff55ff", "14=#55ffff", "15=#ffffff",
  },
}

-- Helpers
local function trim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function basename(path)
  path = (path or ""):gsub("/+$", "")
  return path:match("([^/]+)$") or path
end

local function current_cwd(ctx)
  if ctx.block_id ~= nil then
    local proc, err = rex.block.call("com.superlogical.terminal", "process", {})
    if proc ~= nil and proc.foreground ~= nil and proc.foreground.cwd ~= nil and proc.foreground.cwd ~= "" then
      return proc.foreground.cwd
    end
  end
  return os.getenv("HOME")
end

-- Custom actions
rex.action {
  name = "last_session_toggle",
  title = "Toggle Last Session",
  description = "Switch back and forth between the current and previous session.",
  run = function(ctx, args)
    local tracked_current, tracked_last = read_last_session_state()
    if tracked_current ~= nil and not session_exists(tracked_current) then
      tracked_current = ctx.session_id
    end
    -- Prefer the session the tracker has seen the app focus, since ctx.session_id
    -- can identify the calling client's own session rather than the one on screen.
    local cur = tracked_current or ctx.session_id

    -- The tracker records focus changes, but if it has not seen this session yet
    -- (for example right after a server restart), repair the state from the
    -- invocation itself.
    if tracked_current ~= nil and tracked_current ~= cur then
      tracked_last = tracked_current
      tracked_current = cur
      write_last_session_state(tracked_current, tracked_last)
    elseif tracked_current == nil then
      tracked_current = cur
      write_last_session_state(tracked_current, tracked_last)
    end

    -- Fall back to the in-memory state when the tracker has no previous session.
    if tracked_last == nil then
      tracked_last = last_session_id
    end
    if current_session_id ~= nil and current_session_id ~= cur and tracked_last == nil then
      tracked_last = current_session_id
    end

    local target = tracked_last
    -- If the remembered session was closed, drop it instead of erroring.
    if target ~= nil and not session_exists(target) then
      tracked_last = nil
      write_last_session_state(tracked_current, nil)
      target = nil
    end
    if target ~= nil and target ~= cur then
      -- Record the switch optimistically so a later manual switch is measured
      -- from the session we are about to focus.
      write_last_session_state(target, cur)
      rex.client.queue("session.select", { session_id = target })
    end

    current_session_id = cur
    last_session_id = target
    return true
  end,
}

rex.action {
  name = "sessionizer",
  title = "Open Project Session (Fuzzy)",
  description = "Fuzzy-find a project directory and open or switch to its session.",
  run = function(ctx, args)
    local script = os.getenv("HOME") .. "/.local/bin/rex-sessionizer"
    local r, err = rex.session.new_layer {
      session_id = ctx.session_id,
      bounds = { 0.2, 0.2, 0.6, 0.6 },
      layout = {
        block = {
          flavor = "com.superlogical.terminal.shell",
          options = {
            command = { script },
            theme = GHOSTTY_THEME,
          },
        },
      },
      focus = true,
    }
    if r == nil then error(err or "failed to open sessionizer", 0) end
    rex.exec({ "sleep", "0.2" })
    return true
  end,
}

-- Themed new tab (matches Ghostty colors)
rex.action {
  name = "new_tab",
  title = "New Tab",
  description = "Open a new tab with the Ghostty theme applied.",
  run = function(ctx, args)
    local w, err = rex.session.new_window {
      session_id = ctx.session_id,
      layout = {
        block = {
          flavor = "com.superlogical.terminal.shell",
          options = { cwd = current_cwd(ctx), theme = GHOSTTY_THEME },
        },
      },
    }
    if w == nil then error(err or "failed to create tab", 0) end
    rex.client.queue("session.select", {
      session_id = ctx.session_id,
      window_id = w.window_id,
    })
    rex.exec({ "sleep", "0.2" })
    return true
  end,
}

rex.action {
  name = "split_right",
  title = "Split Right",
  description = "Split the focused pane to the right, keeping the current directory.",
  run = function(ctx, args)
    local r, err = rex.session.new_split {
      session_id = ctx.session_id,
      anchor_id = ctx.block_id,
      direction = "horizontal",
      side = "after",
      layout = {
        block = {
          flavor = "com.superlogical.terminal.shell",
          options = { cwd = current_cwd(ctx), theme = GHOSTTY_THEME },
        },
      },
      focus = true,
    }
    if r == nil then error(err or "failed to split", 0) end
    return true
  end,
}

rex.action {
  name = "split_down",
  title = "Split Down",
  description = "Split the focused pane downward, keeping the current directory.",
  run = function(ctx, args)
    local r, err = rex.session.new_split {
      session_id = ctx.session_id,
      anchor_id = ctx.block_id,
      direction = "vertical",
      side = "after",
      layout = {
        block = {
          flavor = "com.superlogical.terminal.shell",
          options = { cwd = current_cwd(ctx), theme = GHOSTTY_THEME },
        },
      },
      focus = true,
    }
    if r == nil then error(err or "failed to split", 0) end
    return true
  end,
}

rex.action {
  name = "apply_ghostty_theme",
  title = "Apply Ghostty Theme to Focused Pane",
  description = "Apply the Ghostty colors to the focused terminal.",
  run = function(ctx, args)
    if ctx.block_id == nil then return true end
    local _, err = rex.block.call("com.superlogical.terminal", "set_theme", GHOSTTY_THEME)
    if err ~= nil then error(err, 0) end
    return true
  end,
}

-- Keybindings (leader = ctrl+space, written as sequences)
-- Tabs / windows
rex.bind("ctrl+space>c", "new_tab")
rex.bind("cmd+t", "new_tab")
rex.bind("ctrl+space>t", "apply_ghostty_theme")

rex.action {
  name = "import_ghostty_theme",
  title = "Import Ghostty Theme",
  description = "Import the flattened Ghostty theme file into Rex.",
  run = function(ctx, args)
    rex.client.queue("client.theme.import", {
      path = os.getenv("HOME") .. "/.config/rex/ghostty-theme.conf",
    })
    return true
  end,
}
rex.bind("ctrl+space>x", "pane.close")
rex.bind("ctrl+space>shift+x", "client.tab.close")
rex.bind("ctrl+space>n", "client.tab.next")
rex.bind("ctrl+space>p", "client.tab.previous")
rex.bind("ctrl+space>shift+h", "client.tab.move.backward")
rex.bind("ctrl+space>shift+l", "client.tab.move.forward")
rex.bind("ctrl+space>z", "pane.zoom")

-- Jump to a tab by number (ctrl+space, then the digit). Mirrors herdr's
-- prefix+number tab navigation. Rex shows the ⌘1..⌘9 badges when holding
-- Cmd; during a ctrl+space sequence the legend is not shown yet (see the
-- open "Consistent tab numbering" feedback), so count tabs from the tab bar.
for i = 1, 9 do
  rex.bind("ctrl+space>" .. tostring(i), "client.tab.goto", { index = i })
end

-- Splits
rex.bind("ctrl+space>v", "split_right")
rex.bind("ctrl+space>-", "split_down")
rex.bind("cmd+d", "split_right")

-- Pane focus (alt+arrows, no leader)
rex.bind("alt+left", "pane.focus.left")
rex.bind("alt+right", "pane.focus.right")
rex.bind("alt+up", "pane.focus.up")
rex.bind("alt+down", "pane.focus.down")

-- Seamless nvim <-> Rex pane navigation (ctrl+h/j/k/l), like vim-tmux-navigator.
-- If the focused pane is running (n)vim, the key is passed through so nvim can
-- move between its own splits; nvim calls `rex focus <dir>` when it hits the
-- edge (see nvim/lua/plugins/rex-navigator.lua). Otherwise Rex moves focus.
local VIM_PROCESS_NAMES = { nvim = true, vim = true, vi = true, view = true, vimdiff = true }

local function focused_is_vim()
  local proc = rex.block.call("com.superlogical.terminal", "process", {})
  local fg = type(proc) == "table" and proc.foreground or nil
  if type(fg) ~= "table" then return false end
  local name = basename(fg.name or fg.argv0 or "")
  return VIM_PROCESS_NAMES[name] == true
end

for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+" .. key, function(ctx, ev)
    if focused_is_vim() then
      return false -- let nvim handle it
    end
    rex.session.focus_direction({ session_id = ctx.session_id, direction = dir })
    return true
  end)
end

-- Pane resize (ctrl+arrows)
rex.bind("ctrl+left", "pane.resize", { direction = "left" })
rex.bind("ctrl+right", "pane.resize", { direction = "right" })
rex.bind("ctrl+up", "pane.resize", { direction = "up" })
rex.bind("ctrl+down", "pane.resize", { direction = "down" })

-- Sessions / workspaces
rex.bind("ctrl+space>j", "sessionizer")
rex.bind("ctrl+space>o", "session.new")
rex.bind("ctrl+space>space", "session.switch")
rex.bind("ctrl+space>tab", "last_session_toggle")
rex.bind("ctrl+space>a", "client.sidebar.activity.toggle")
-- Close the whole session: every tab and pane, and the programs running in them.
rex.bind("ctrl+space>shift+d", "session.close")

-- Send the leader through to the terminal when pressed twice
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })

-- Optional: a resize mode entered with ctrl+space>r
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+space>r", "client.mode.enter", { name = "resize", once = false })
rex.bind("resize/left", "pane.resize", { direction = "left" })
rex.bind("resize/right", "pane.resize", { direction = "right" })
rex.bind("resize/up", "pane.resize", { direction = "up" })
rex.bind("resize/down", "pane.resize", { direction = "down" })
rex.bind("resize/shift+left", "pane.resize", { direction = "left", amount = 15 })
rex.bind("resize/shift+right", "pane.resize", { direction = "right", amount = 15 })
rex.bind("resize/shift+up", "pane.resize", { direction = "up", amount = 15 })
rex.bind("resize/shift+down", "pane.resize", { direction = "down", amount = 15 })
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
rex.bind("resize/escape", "client.mode.exit")
