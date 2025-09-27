local colors = require("colors")

SBAR.add(
	"event",
	"lock",
	"com.apple.screenIsLocked"
)

SBAR.add(
	"event",
	"unlock",
	"com.apple.screenIsUnlocked"
)

local animator = SBAR.add("item", {
	position = "left",
	drawing = "off",
	updates = "on",
})

local function lock()
	SBAR.bar({
		y_offset = -32,
		margin = -200,
		notch_width = 0,
		color = TO_FULL_COLORS(colors.black, 0),
	})
end

local function unlock()
	SBAR.animate("sin", 30, function()
		SBAR.bar({
			y_offset = 4,
			margin = 8,
			notch_width = 200,
			color = TO_FULL_COLORS(colors.night.dark, 50),
		})
	end)
end

animator:subscribe("lock", lock)
animator:subscribe("unlock", unlock)
