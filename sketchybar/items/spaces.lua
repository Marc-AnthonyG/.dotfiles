local colors = require("colors")
local get_icon = require("icons")

SBAR.add("event", "window_change")

local spaces = {}
local white = TO_FULL_COLORS(colors.white, 100)
local selected_color = TO_FULL_COLORS(colors.blue.sky, 100)

local function set_label_as_app_icon(item, SID)
  SBAR.exec("yabai -m query --windows --space " .. SID .. "| jq '.[].app'", function(apps)
    local label = ""

    if apps and apps ~= "" then
      local apps_arr = {}
      for line in apps:gmatch("[^\r\n]+") do
        local app_name = line:gsub('"', '')
        table.insert(apps_arr, app_name)
      end

      local length = #apps_arr

      for j, app_name in ipairs(apps_arr) do
        local icon = get_icon(app_name)
        label = label .. icon
        if j < length then
          label = label .. " "
        end
      end
    else
      label = "_"
    end

    item:set({ label = label })
  end)
end

local function space_selection(env)
  local sid_num = tonumber(env.SID)
  local item = spaces[sid_num]
  if env.SELECTED == "true" then
    item:set({
      background = { drawing = "on" },
      icon = { color = selected_color },
      label = { color = selected_color }
    })
  else
    item:set({
      background = { drawing = "off" },
      icon = { color = white },
      label = { color = white }
    })
  end

  set_label_as_app_icon(item, env.SID)
end

local function on_hover(env)
  local item = spaces[tonumber(env.SID)]

  if env.SENDER == "mouse.entered" then
    item:set({
      icon = { color = colors.hover_color },
      label = { color = colors.hover_color },
      background = { drawing = "on", color = TO_FULL_COLORS(colors.night.lighter, 80) },
    })
  elseif env.SENDER == "mouse.exited" then
    item:set({
      icon = { color = env.SELECTED == "true" and selected_color or white },
      label = { color = env.SELECTED == "true" and selected_color or white },
      background = {
        drawing = env.SELECTED == "true" and "on" or "off",
        color = TO_FULL_COLORS(colors.white, 26),
      },
    })
  end
end


for sid = 1, 8, 1 do
  local space = SBAR.add("space", "space." .. sid, {
    associated_space = sid,
    background = {
      color = TO_FULL_COLORS(colors.white, 26),
      corner_radius = 5,
      height = 20,
      drawing = "off",
    },
    icon = sid .. ":",
    label = {
      string = "_",
      font = { size = "18.0" },
    },
    click_script = "yabai -m space --focus " .. sid,
  })

  spaces[sid] = space
  space:subscribe("mouse.entered", on_hover)
  space:subscribe("mouse.exited", on_hover)
  space:subscribe("space_change", space_selection)
end
