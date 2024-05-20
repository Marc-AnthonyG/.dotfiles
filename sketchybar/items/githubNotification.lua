local colors = require("colors")

local function custom_config_with_type(notifInfo, notifItem, parentName)
  local type = notifInfo.subject.type
  local color, icon, padding = " 0xff9dd274", "􀍷", 0
  local finalUrl = "https://www.github.com/notifications"

  if type == "Issue" then
    color = TO_FULL_COLORS(colors.extra.orange, 100)
    icon = "􀍷"
    padding = 0
  elseif type == "Discussion" then
    color = TO_FULL_COLORS(colors.blue.sky, 100)
    icon = "􀒤"
    padding = 0
  elseif type == "PullRequest" then
    color = TO_FULL_COLORS(colors.extra.green, 100)
    color = "0xffba9cf3"
    icon = "􀙡"
    padding = 4
  elseif type == "CheckSuite" then
    color = TO_FULL_COLORS(colors.red.light, 100)
    icon = "􀙡"
    padding = 4
  end

  notifItem:set({
    icon = {
      string = icon,
      padding_left = padding,
      color = color,
      font = {
        size = 18
      },
    },
    click_script = string.format(
      "open %s; sketchybar --set %s popup.drawing=toggle",
      finalUrl,
      parentName
    ),
  })
end

local function create(notif, count, parentItem)
  local parentName = parentItem.name
  local title = notif.subject.title

  local item = sbar.add("item", "github.notifications." .. count, {
    position = "popup." .. parentName,
    label = {
      string = title,
      font = {
        size = 10
      },
    },
    icon = {
      font = {
        size = 10
      },
    },
    update_freq = 180,
  })

  custom_config_with_type(notif, item, parentName)
  local function on_hover(env)
    if env.SENDER == "mouse.entered" then
      item:set({
        background = { color = TO_FULL_COLORS(colors.night.light, 100), drawing = "on" },
      })
    elseif env.SENDER == "mouse.exited" then
      item:set({
        background = { drawing = "off" },
      })
    end
  end
  item:subscribe("mouse.entered", on_hover)
  item:subscribe("mouse.exited", on_hover)
end

return {
  create = create
}
