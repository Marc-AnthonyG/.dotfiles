local colors = require("colors")

local function custom_config_with_type(notifInfo, notifItem)
  local type = notifInfo.subject.type
  local defaultUrl = "https://www.github.com/notifications"
  local click_script_text = "open %s && sketchybar -m --trigger git_notif_click &> /dev/null"

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
            click_script_text,
            result
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
        click_script_text,
        defaultUrl
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
            click_script_text,
            result
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
        click_script_text,
        defaultUrl
      ),
    })
  end
end

local function create(notif, parentItem, item_name)
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



  local item = SBAR.add("item", item_name, {
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

  custom_config_with_type(notif, item)

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
