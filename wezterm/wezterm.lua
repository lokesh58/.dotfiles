local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font_size = 12
config.font = wezterm.font("MesloLGM Nerd Font")

return config
