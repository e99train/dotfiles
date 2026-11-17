-- Track the most recently focused Rex session, for the last_session_toggle action.
-- Run with: rex do ~/.config/rex/track-last-session.lua --all

local STATE_DIR = os.getenv("HOME") .. "/.local/state/rex"
local STATE_FILE = STATE_DIR .. "/last-session.txt"

local app_clients = {}

local function read_state()
  local cur, last
  local f = io.open(STATE_FILE, "r")
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

local function write_state(cur, last)
  rex.exec({ "mkdir", "-p", STATE_DIR })
  local f = io.open(STATE_FILE, "w")
  if not f then return end
  if cur and cur ~= "" then f:write("current=" .. cur .. "\n") end
  if last and last ~= "" then f:write("last=" .. last .. "\n") end
  f:close()
end

local current, last = read_state()

-- Seed the set of app clients already connected.
local clients = rex.call("client.list")
if type(clients) == "table" and type(clients.clients) == "table" then
  for _, c in ipairs(clients.clients) do
    if type(c) == "table" and type(c.info) == "table" and c.info.kind == "app" then
      app_clients[c.client_id] = true
    end
  end
end

rex.on("client_joined", function(ctx, ev)
  if type(ev) == "table" and type(ev.client) == "table"
     and type(ev.client.info) == "table" and ev.client.info.kind == "app" then
    app_clients[ev.client.client_id] = true
  end
end)

rex.on("client_changed", function(ctx, ev)
  if type(ev) == "table" and type(ev.client) == "table" then
    if type(ev.client.info) == "table" and ev.client.info.kind == "app" then
      app_clients[ev.client.client_id] = true
    else
      app_clients[ev.client.client_id] = nil
    end
  end
end)

rex.on("client_left", function(ctx, ev)
  if type(ev) == "table" and ev.client_id then
    app_clients[ev.client_id] = nil
  end
end)

rex.on("session_destroyed", function(ctx, ev)
  if type(ev) ~= "table" then return end
  local sid = ev.session_id
  if type(sid) ~= "string" or sid == "" then return end
  local changed = false
  if sid == current then
    current = nil
    changed = true
  end
  if sid == last then
    last = nil
    changed = true
  end
  if changed then write_state(current, last) end
end)

rex.on("block_event", function(ctx, ev)
  if type(ev) ~= "table" then return end
  if ev.creator_name ~= "com.superlogical.terminal" then return end
  if ev.name ~= "size_changed" then return end
  local payload = ev.payload
  if type(payload) ~= "table" then return end
  if not (payload.owner and app_clients[payload.owner]) then return end
  local sid = ev.session_id or ctx.session_id
  if type(sid) ~= "string" or sid == "" then return end
  if sid ~= current then
    last = current
    current = sid
    write_state(current, last)
  end
end)
