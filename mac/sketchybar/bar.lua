local colors = require("colors")

SBAR.bar({
	height = 32,
	y_offset = 4,
	position = 'top',
	blur_radius = 0,
	sticky = 'off',
	padding_left = 10,
	padding_right = 10,
	color = TO_FULL_COLORS(colors.night.dark, 50),
	margin = 8,
	corner_radius = 16,
	notch_width = 200,
})
