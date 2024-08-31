local battery = SBAR.add("item", {
	position = "right",
	update_freq = 120,
})

local function battery_update()
	SBAR.exec("pmset -g batt", function(batt_info)
		local icon = "!"
		local label = ""
		local drawLabel = "on"

		if (string.find(batt_info, 'AC Power')) then
			drawLabel = "off"
			icon = ""
		else
			local found, _, charge = batt_info:find("(%d+)%%")
			if found then
				charge = tonumber(charge)
				label = charge .. "%"
			end

			if found and charge > 80 then
				icon = ""
			elseif found and charge > 60 then
				icon = ""
			elseif found and charge > 35 then
				icon = ""
			elseif found and charge > 10 then
				icon = ""
			else
				icon = ""
			end
		end

		battery:set({ icon = icon, label = { string = label, drawing = drawLabel } })
	end)
end


battery:subscribe({ "routine", "power_source_change", "system_woke" }, battery_update)
