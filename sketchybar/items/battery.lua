local battery = sbar.add("item", {
  position = "right",
  update_freq = 120,
})

local function battery_update()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = "!"
    local label = ""

    if (string.find(batt_info, 'AC Power')) then
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
      elseif found and charge > 40 then
        icon = ""
      elseif found and charge > 20 then
        icon = ""
      else
        icon = ""
      end
    end

    battery:set({ icon = icon, label = label})
  end)
end


battery:subscribe({"routine", "power_source_change", "system_woke"}, battery_update)
