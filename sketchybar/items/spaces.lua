local colors = require("colors")
local get_icon = require("icons")

SBAR.add("event", "window_change")

local spaces = {}
local white = TO_FULL_COLORS(colors.white, 100)
local selected_color = TO_FULL_COLORS(colors.blue.sky, 100)

local function set_label_as_app_icon(item, SID)
	SBAR.exec(
		"yabai -m query --windows --space " ..
		SID .. "| jq '[.[] | select(.subrole != \"AXSystemDialog\") | .app]'",
		function(apps)
			local label = "_"
			if #apps > 0 then
				label = ""

				local length = #apps
				for j, app_info in ipairs(apps) do
					local app_name = app_info.app
					local icon = get_icon(app_name)
					label = label .. icon

					if j < length then
						label = label .. " "
					end
				end
			end

			item:set({ label = label })
		end)
end

local function space_selection(env)
	local sid_num = tonumber(env.SID)
	local item = spaces[sid_num]

	if env.SELECTED == "true" then
		item:set({
			background = { drawing = "on" },
			icon = { color = selected_color },
			label = { color = selected_color }
		})
	else
		item:set({
			background = { drawing = "off" },
			icon = { color = white },
			label = { color = white }
		})
	end

	set_label_as_app_icon(item, env.SID)
end


for sid = 1, 8, 1 do
	local space = SBAR.add("space", "space." .. sid, {
		associated_space = sid,
		background = {
			color = TO_FULL_COLORS(colors.white, 26),
			corner_radius = 5,
			height = 20,
			drawing = "off",
		},
		icon = sid .. ":",
		label = {
			string = "_",
			font = { size = "18.0" },
		},
		click_script = "yabai -m space --focus " .. sid,
	})

	spaces[sid] = space
	space:subscribe("space_change", space_selection)
	space:subscribe("window_change", space_selection)
end
