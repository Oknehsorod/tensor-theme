local naughty = require('naughty')
local xresources = require('beautiful.xresources')

local dpi = xresources.apply_dpi

local module = {}

function module.init()
  naughty.config.padding = dpi(25)
  naughty.config.defaults.margin = dpi(24)
end

return module
