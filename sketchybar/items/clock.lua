local clock = sbar.add("item", {
  position = "right",
  update_freq = 10,
  icon = ""
})

local function set_time()
  local time = os.date("%d/%m %h:%m")
  clock:set({ label = time })
end

clock:subscribe("routine", set_time)

set_time()
