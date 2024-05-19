local colors = require("colors")

sbar.add("event", "window_change")

local spaces = {}

local function update_space(env)
  print("update_space", env.SID)
end

for sid = 1, 8, 1 do
  local space = sbar.add("space", "space." .. sid, {
    associated_space = sid,
    icon = {
      string = sid .. ":",
      color = TO_FULL_COLORS(colors.white, 100)
    },
    background = {
      corner_radius = 5,
      height = 20,
      drawing = "off",
    },
    label = {
      string = "_",
      font = { size = "18.0" },
    },
    click_script = "yabai -m space --focus $sid",
    script = update_space,
  })

  spaces[sid] = space

  space:subscribe("window_change", update_space)
  space:subscribe("space_change", update_space)
end
