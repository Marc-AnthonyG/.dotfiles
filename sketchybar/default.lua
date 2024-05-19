local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = 'Hack Nerd Font',
      style = "Bold",
      size = 17.0
    },
    color = TO_FULL_COLORS(colors.white, 100),
    padding_left = 4,
    padding_right = 4,
  },
  label = {
    font = {
      family = 'Hack Nerd Font',
      style = "Bold",
      size = 14.0
    },
    color = TO_FULL_COLORS(colors.white, 100),
    padding_left = 4,
    padding_right = 4,
  },
  padding_left = 5,
  padding_right = 5
})
