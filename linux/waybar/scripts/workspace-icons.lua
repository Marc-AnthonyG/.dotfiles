#!/usr/bin/env lua

-- Get workspace number from command line argument
local target_workspace = tonumber(arg and arg[1]) or 1

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
		return nil
	end
	local result = handle:read("*a")
	handle:close()
	return result:gsub("%s+$", "")
end

-- Get active workspace ID
local function get_active_workspace()
	local cmd = "hyprctl activewindow -j | jq -r '.workspace.id // 1'"
	local result = execute_command(cmd)
	return tonumber(result) or 1
end

-- Get workspace apps
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

-- Main function
local function main()
	local active_workspace = get_active_workspace()
	local workspace_apps = get_workspace_apps(target_workspace)

	local icons = {}

	-- Collect icons for this workspace
	if #workspace_apps > 0 then
		for _, app in ipairs(workspace_apps) do
			local icon = get_icon(app)
			table.insert(icons, icon)
		end
	end

	-- Determine CSS class
	local css_class = ""
	if target_workspace == active_workspace then
		css_class = "active"
	end

	-- Build display text
	local display_text
	if #icons > 0 then
		display_text = target_workspace .. ":" .. table.concat(icons, " ")
	else
		display_text = tostring(target_workspace)
	end

	-- Build tooltip
	local tooltip = "Workspace " .. target_workspace
	if #workspace_apps > 0 then
		tooltip = tooltip .. " (" .. #workspace_apps .. " windows): " .. table.concat(workspace_apps, ", ")
	else
		tooltip = tooltip .. " (empty)"
	end

	-- Output JSON
	display_text = display_text:gsub('"', '\\"')
	tooltip = tooltip:gsub('"', '\\"')

	print(string.format('{"text": "%s", "tooltip": "%s", "class": "%s"}', display_text, tooltip, css_class))
end

-- Error handling
local function safe_main()
	local success, error_msg = pcall(main)
	if not success then
		print(string.format('{"text": "%d", "tooltip": "Error", "class": ""}', target_workspace))
	end
end

safe_main()
