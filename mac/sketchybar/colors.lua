-- Colors from https://lospec.com/palette-list/tokyo-night
function TO_FULL_COLORS(color, transparency_percentage)
	if transparency_percentage < 0 or transparency_percentage > 100 then
		error("Transparency percentage must be between 0 and 100")
	end
	local transparency = math.floor(transparency_percentage / 100 * 255)
	return string.format("0x%02x%06x", transparency, color)
end

return {
	black = 0x1f2335,
	white = 0xffffff,

	night = {
		darker = 0x24283b,
		dark = 0x292e42,
		night = 0x3b4261,
		light = 0x414868,
		lighter = 0x545c7e,
	},

	blue = {
		gray = 0x565f89,
		navy = 0x394b70,
		blue = 0x3d59a1,
		light = 0x7aa2f7,
		sky = 0x7dcfff,
		green = 0xb4f9f8,
	},

	extra = {
		pink = 0xbb9af7,
		purple = 0x9d7cd8,
		orange = 0xff9e64,
		yellow = 0xffc777,
		green = 0xc3e88d,
	},

	red = {
		light = 0xff757f,
		dark = 0xc53b53,
		flash = 0xff007c,
	},

	hover_color = TO_FULL_COLORS(0xff9e64e, 100),
}
