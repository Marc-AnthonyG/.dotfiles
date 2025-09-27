local volume = SBAR.add("item", {
	position = "right",
})


local function set_volume(env)
	local volume_value = tonumber(env.INFO)
	if volume_value >= 50 then
		volume:set({ label = volume_value .. "%", icon = "" })
	elseif volume_value > 0 then
		volume:set({ label = volume_value .. "%", icon = "󰖀" })
	else
		volume:set({ label = "Muted", icon = "󰖁" })
	end
end

volume:subscribe("volume_change", set_volume)
