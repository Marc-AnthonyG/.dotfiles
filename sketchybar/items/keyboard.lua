local keyboard = sbar.add("item", {
  position = "right",
  icon = "",
  update_freq = 10,
})

--[[
local keyboard_event = sbar.add(
  "event",
  "keyboard_change",
  "AppleSelectedInputSourcesChangedNotification"
)
--]]

local function getKeyboardLayout()
  sbar.exec(
    "defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep 'KeyboardLayout Name' | cut -c 33- | rev | cut -c 2- | rev",
    function(result)
      if result == "Canadian" then
        keyboard.set({ label = 'CA' })
      elseif result == "Canadian - CSA" then
        keyboard.set({ label = 'CSA' })
      else
        keyboard.set({ drawing = false })
      end
    end)
end

keyboard:subscribe("routine", getKeyboardLayout)
