local clock = SBAR.add("item", {
  position = "right",
  update_freq = 10,
  icon = ""
})

local function set_time()
  local time = os.date("%d/%m %H:%M")
  clock:set({ label = time })
end

clock:subscribe("routine", set_time)

set_time()
