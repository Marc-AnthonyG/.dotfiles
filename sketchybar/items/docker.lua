local colors = require("colors")

local docker = SBAR.add("item", {
  position = "right",
  label = { drawing = "off" },
  update_freq = 60,
})


local function set_docker_running()
  SBAR.exec("pgrep -f Docker.app > /dev/null && echo true || echo false", function(result)
    if (result == "true\n") then
      docker:set({ icon = { string = "", color = TO_FULL_COLORS(colors.white, 100) } })
    else
      docker:set({ icon = { string = "", color = TO_FULL_COLORS(colors.red.dark, 100) } })
    end
  end)
end

docker:subscribe("routine", set_docker_running)

docker:subscribe("mouse.clicked", function()
  SBAR.exec("open -a 'Docker'")
  docker:set({ icon = { string = "", color = TO_FULL_COLORS(colors.white, 100) } })
end)

set_docker_running()
