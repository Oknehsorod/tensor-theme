local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local lain  = require("lain")

local inspect = require("inspect.inspect")
local naughty = require("naughty")

local dpi = xresources.apply_dpi

local theme = {};

local function print(value)
  naughty.notify({ title = "DEBUG", text = inspect(value) })
end

theme.create_ui = function (screen)
end

theme.create_titlebar = function (screen)
end

print("Babadgi")

return theme
