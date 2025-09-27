#!/usr/bin/env lua

-- Icon mapping function
local function get_icon(app_class)
	local icons = {
		["google-chrome"] = "",
		["Alacritty"] = "",
		["Spotify"] = "󰓇",
		["Obsidian"] = "󱞎",
		["org.kde.dolphin"] = "",
		["org.pulseaudio.pavucontrol"] = "",
		["gimp"] = "",
	}
	return icons[app_class] or "*"
end

-- Execute command and return output
local function execute_command(cmd)
	local handle = io.popen(cmd)
	if handle == nil then
		return ""
	end
	local result = handle:read("*a")
	handle:close()
	return result:gsub("%s+$", "") -- trim trailing whitespace
end

-- Get active workspace ID using jq
local function get_active_workspace()
	local cmd = "hyprctl activewindow -j | jq -r '.workspace.id // 1'"
	local result = execute_command(cmd)
	local workspace_id = tonumber(result)
	return workspace_id or 1
end

-- Get workspace apps using jq
local function get_workspace_apps(workspace_id)
	local cmd =
		string.format("hyprctl clients -j | jq -r '.[] | select(.workspace.id == %d) | .class' | sort -u", workspace_id)
	local result = execute_command(cmd)

	local apps = {}
	if result and result ~= "" then
		for app in result:gmatch("[^\r\n]+") do
			if app and app ~= "" and app ~= "null" then
				table.insert(apps, app)
			end
		end
	end
	return apps
end

local function main()
	-- Get active workspace
	local active_workspace = get_active_workspace()

	local text_parts = {}

	-- Process each workspace (1-6)
	for workspace = 1, 6 do
		local workspace_apps = get_workspace_apps(workspace)
		local icons = {}

		if #workspace_apps > 0 then
			for _, app in ipairs(workspace_apps) do
				table.insert(icons, get_icon(app))
			end
		end

		local workspace_text

		if workspace == active_workspace then
			if #icons > 0 then
				workspace_text = string.format("<b>%d:%s</b>", workspace, table.concat(icons, " "))
			else
				workspace_text = string.format("<b>%d</b>", workspace)
			end
		else
			if #icons > 0 then
				workspace_text = string.format("%d:%s", workspace, table.concat(icons, " "))
			else
				workspace_text = tostring(workspace)
			end
		end

		table.insert(text_parts, workspace_text)
	end

	local final_text = table.concat(text_parts, " ")

	-- Output JSON for waybar (manual formatting, escape any quotes)
	final_text = final_text:gsub('"', '\\"')
	print('{"text": "' .. final_text .. '"}')
end

-- Error handling wrapper
local function safe_main()
	local success, error_msg = pcall(main)
	if not success then
		-- Output error as waybar text for debugging
		print('{"text": "Error: ' .. (error_msg or "unknown") .. '"}')
	end
end

-- Run the main function with error handling
safe_main()
