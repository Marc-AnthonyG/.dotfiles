local colors = require("colors")
local get_icon = require("icons")

sbar.add("event", "window_change")

local spaces = {}

local function space_selection(env)
  local sid_num = tonumber(env.SID)
  local item = spaces[sid_num]
  if env.SELECTED == "true" then
    item:set({ background = { drawing = "on" } })
  else
    item:set({ background = { drawing = "off" } })
  end


  sbar.exec("yabai -m query --windows --space " .. env.SID .. "| jq '.[].app'", function(apps)
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


for sid = 1, 8, 1 do
  local space = sbar.add("space", "space." .. sid, {
    associated_space = sid,
    icon = {
      string = sid .. ":",
      color = TO_FULL_COLORS(colors.white, 100)
    },
    background = {
      color = "0x44ffffff",
      corner_radius = 5,
      height = 20,
      drawing = "off",
    },
    label = {
      string = "_",
      font = { size = "18.0" },
    },
    click_script = "yabai -m space --focus " .. sid,
  })

  spaces[sid] = space
  space:subscribe("space_change", space_selection)
end
