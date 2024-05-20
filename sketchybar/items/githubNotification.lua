local colors = require("colors")

local function custom_config_with_type(notifInfo, notifItem, parentName)
  local type = notifInfo.subject.type
  local defaultUrl = "https://www.github.com/notifications"

  if type == "Issue" then
    SBAR.exec("gh api " .. notifInfo.subject.url .. "| jq .html_url",
      function(result)
        notifItem:set({
          icon = {
            string = "􀍷",
            padding_left = 0,
            color = TO_FULL_COLORS(colors.extra.orange, 100)
          },
          click_script = string.format(
            "open %s; sketchybar --set %s popup.drawing=toggle",
            result,
            parentName
          ),
        })
      end)
  elseif type == "Discussion" then
    notifItem:set({
      icon = {
        string = "􀒤",
        padding_left = 0,
        color = TO_FULL_COLORS(colors.blue.sky, 100)
      },
      click_script = string.format(
        "open %s; sketchybar --set %s popup.drawing=toggle",
        defaultUrl,
        parentName
      ),
    })
  elseif type == "PullRequest" then
    SBAR.exec("gh api " .. notifInfo.subject.url .. "| jq .html_url",
      function(result)
        notifItem:set({
          icon = {
            string = "􀙡",
            padding_left = 4,
            color = TO_FULL_COLORS(colors.extra.green, 100)
          },
          click_script = string.format(
            "open %s; sketchybar --set %s popup.drawing=toggle",
            result,
            parentName
          ),
        })
      end)
  elseif type == "CheckSuite" then
    notifItem:set({
      icon = {
        string = "􀙡",
        padding_left = 4,
        color = TO_FULL_COLORS(colors.red.light, 100)
      },
      click_script = string.format(
        "open %s; sketchybar --set %s popup.drawing=toggle",
        defaultUrl,
        parentName
      ),
    })
  end
end

local function create(notif, count, parentItem)
  local parentName = parentItem.name
  local title = notif.subject.title

  if #title >= 95 then
    local truncated = title:sub(1, 95)
    local last_space = truncated:match(".*[%s%-_]()")

    if last_space then
      truncated = title:sub(1, last_space - 1)
    end

    title = truncated .. "..."
  end



  local item = SBAR.add("item", "github.notifications." .. count, {
    position = "popup." .. parentName,
    label = {
      string = title,
      font = {
        size = 10
      },
    },
    icon = {
      font = {
        size = 18
      },
    },
    width = 600,
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
