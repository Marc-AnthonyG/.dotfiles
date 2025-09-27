#!/usr/bin/env lua

-- Icon mapping function
local function get_icon(app_class)
	local icons = {
		["google-chrome"] = "",
		["Alacritty"] = "",
		["Spotify"] = "󰓇",
		["Obsidian"] = "󱞎",
		["org.kde.dolphin"] = "",
		["org.pulseaudio.pavucontrol"] = "",
		["gimp"] = "",
	}
	return icons[app_class] or "*"
end

-- Execute command and return output
local function execute_command(cmd)
	local handle = io.popen(cmd)
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
	local text_parts = {}
	local tooltip_parts = {}
	local total_windows = 0

	-- Process each workspace (1-6)
	for workspace = 1, 6 do
		local workspace_apps = get_workspace_apps(workspace)
		local icons = {}

		if #workspace_apps > 0 then
			total_windows = total_windows + #workspace_apps
			for _, app in ipairs(workspace_apps) do
				local icon = get_icon(app)
				table.insert(icons, icon)
			end
		end

		local workspace_text

		if workspace == active_workspace then
			if #icons > 0 then
				workspace_text = string.format(
					'<span class="workspace-active-occupied">%d:%s</span>',
					workspace,
					table.concat(icons, " ")
				)
			else
				workspace_text = string.format('<span class="workspace-active-empty">%d</span>', workspace)
			end
		else
			if #icons > 0 then
				workspace_text =
					string.format('<span class="workspace-occupied">%d:%s</span>', workspace, table.concat(icons, " "))
			else
				workspace_text = string.format('<span class="workspace-empty">%d</span>', workspace)
			end
		end

		table.insert(text_parts, workspace_text)

		-- Build tooltip info
		if #workspace_apps > 0 then
			table.insert(
				tooltip_parts,
				string.format("Workspace %d: %s", workspace, table.concat(workspace_apps, ", "))
			)
		end
	end

	local final_text = table.concat(text_parts, " ")
	local tooltip = table.concat(tooltip_parts, "\\n") .. string.format("\\n\\nTotal windows: %d", total_windows)

	-- Output JSON with enhanced information
	local output = {
		text = final_text,
		tooltip = tooltip,
		class = "workspaces-container",
		percentage = math.min(100, total_windows * 10), -- optional progress indicator
	}

	-- Escape quotes and output
	final_text = final_text:gsub('"', '\\"')
	tooltip = tooltip:gsub('"', '\\"')

	print(
		string.format(
			'{"text": "%s", "tooltip": "%s", "class": "%s", "percentage": %d}',
			final_text,
			tooltip,
			output.class,
			output.percentage
		)
	)
end

-- Error handling
local function safe_main()
	local success, error_msg = pcall(main)
	if not success then
		print('{"text": "Workspaces Error", "class": "workspaces-error"}')
	end
end

safe_main()
