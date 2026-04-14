local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font_size = 12
config.font = wezterm.font("JetBrainsMono Nerd Font")

local windows = require("windows")
windows.apply_to_config(config)

return config
