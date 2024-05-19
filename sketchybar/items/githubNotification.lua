local popup_toggle = "sketchybar --set $NAME popup.drawing=toggle"

local github = sbar.add("item", {
  position = "left",
  icon = "􀋙",
  update_freq = 180,
  click_script = popup_toggle,
  label = "Loading...",
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

local function custom_config_with_type(notif, item)
  local type = notif.subject.type
  local color, icon, padding, finalUrl = " 0xff9dd274", "􀍷", 0, "https://www.github.com/notifications"

  if type == "Issue" then
    color = "0xff9dd274"
    icon = "􀍷"
    padding = 0
  elseif type == "Discussion" then
    color = "0xffe1e3e4"
    icon = "􀒤"
    padding = 0
  elseif type == "PullRequest" then
    color = "0xffba9cf3"
    icon = "􀙡"
    padding = 4
  elseif type == "CheckSuite" then
    color = "0xffba9cf3"
    icon = "􀙡"
    padding = 4
  end

  item:set({
    icon = {
      string = icon,
      padding_left = padding,
      color = color,
    },
    click_script = string.format("open %s; sketchybar --set %s popup.drawing=toggle",
      finalUrl, github.name
    ),
  })
end

local function create_notif(notif, count)
  local title = notif.subject.title

  local item = sbar.add("item", "github.notifications." .. count, {
    position = "popup." .. github.name,
    padding_left = 7,
    padding_right = 7,
    background = {
      color = 0xff3b4261,
      drawing = "on",
    },
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

  custom_config_with_type(notif, item)
end

local function update_github_notification()
  github:set({ label = "Updating..." })
  sbar.exec("gh api notifications",
    function(result)
      set_icon(result)
      for count, value in pairs(result) do
        create_notif(value, count)
      end
    end)
end


github:subscribe("routine", update_github_notification)
update_github_notification()
