local colors = require("colors")

local keyboard = SBAR.add("item", {
  position = "right",
  icon = "",
})

SBAR.add(
  "event",
  "keyboard_change",
  "AppleSelectedInputSourcesChangedNotification"
)

local function getKeyboardLayout()
  SBAR.exec(
    "defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep 'KeyboardLayout Name'",
    function(result)
      local layout = result:match('= (.-);'):gsub('^%s*(.-)%s*$', '%1')
      if layout == "Canadian" then
        keyboard:set({ label = 'CA' })
      elseif layout == "\"Canadian - CSA\"" then
        keyboard:set({ label = 'CSA' })
      else
        keyboard:set({ label = 'Unresolve' })
      end
    end)
end

keyboard:subscribe("keyboard_change", getKeyboardLayout)
getKeyboardLayout()
