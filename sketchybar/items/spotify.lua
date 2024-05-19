local whitelist = { ["Spotify"] = true };

local media = SBAR.add("item", {
  position = "center",
  updates = true,
  icon = "",
  label = "Spotify"
})

media:subscribe("media_change", function(env)
  if whitelist[env.INFO.app] then
    local label = "Not playing"

    if env.INFO.state == "playing" then
      label = env.INFO.artist .. ": " .. env.INFO.title
    end

    media:set({ label = label })
  end
end)
