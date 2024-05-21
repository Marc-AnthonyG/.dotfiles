local colors = require("colors")
local notif = require("items.githubNotification")

local github = SBAR.add("item", {
  position = "left",
  icon = "􀋙",
  update_freq = 5,
  click_script = "sketchybar --set $NAME popup.drawing=toggle",
  label = "Loading...",
  background = {
    drawing = "off",
  },
  popup = {
    drawing = "off",
    background = {
      color = TO_FULL_COLORS(colors.night.dark, 80),
      corner_radius = 8,
      border_color = TO_FULL_COLORS(colors.night.light, 100),
      border_width = 2,
    },
  }
})

local function set_icon(notifications)
  local count = 0
  for _ in pairs(notifications) do count = count + 1 end

  if count == 0 then
    github:set({ icon = "􀋚", label = count })
  else
    github:set({ icon = "􀝗", label = count })
  end
end

local function update_github_notification()
  local bar_data = SBAR.query('bar').items
  local existing_notifs = {}
  local new_notifs = {}

  for _, bar_item_name in ipairs(bar_data) do
    if bar_item_name:match("github.notifications.") then
      existing_notifs[bar_item_name] = true
    end
  end

  SBAR.exec("gh api notifications",
    function(result)
      set_icon(result)
      for _, value in pairs(result) do
        local item_name = "github.notifications." .. value.id
        new_notifs[item_name] = true
        if not existing_notifs[item_name] then
          notif.create(value, github, item_name)
        end
      end

      for item_name in pairs(existing_notifs) do
        if not new_notifs[item_name] then
          SBAR.remove(item_name)
        end
      end
    end)
end


local function on_hover(env)
  if env.SENDER == "mouse.entered" then
    github:set({
      icon = { color = colors.hover_color },
      label = { color = colors.hover_color },
      background = {
        color = TO_FULL_COLORS(colors.night.lighter, 80),
        drawing = "on"
      },
    })
  elseif env.SENDER == "mouse.exited" then
    github:set({
      icon = { color = TO_FULL_COLORS(colors.white, 100) },
      label = { color = TO_FULL_COLORS(colors.white, 100) },
      background = { drawing = "off" },
    })
  end
end

local function handle_click_notif()
  github:set({ popup = { drawing = "toggle" } })

  update_github_notification()
end

SBAR.add("event", "git_notif_click")
github:subscribe("routine", update_github_notification)
github:subscribe("git_notif_click", handle_click_notif)

github:subscribe("mouse.entered", on_hover)
github:subscribe("mouse.exited", on_hover)
update_github_notification()
