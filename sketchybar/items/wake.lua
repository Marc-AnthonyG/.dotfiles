local colors = require("colors")

sbar.add(
  "event",
  "lock",
  "com.apple.screenIsLocked"
)

sbar.add(
  "event",
  "unlock",
  "com.apple.screenIsUnlocked"
)

local animator = sbar.add("item", {
  position = "left",
  drawing = "off",
  updates = "on",
})

local function lock()
  sbar.bar({
    y_offset = -32,
    margin = -200,
    notch_width = 0,
    color = TO_FULL_COLORS(colors.black, 0),
  })
end

local function unlock()
  sbar.animate("sin", 30, function()
    sbar.bar({
      y_offset = 4,
      margin = 8,
      notch_width = 200,
      color = TO_FULL_COLORS(colors.night.dark, 50),
    })
  end)
end

animator:subscribe("lock", lock)
animator:subscribe("unlock", unlock)
