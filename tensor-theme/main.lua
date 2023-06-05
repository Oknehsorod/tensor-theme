local beautiful = require('beautiful')

local keys = require('tensor-theme.keys')
local rules = require('tensor-theme.rules')
local signals = require('tensor-theme.signals')
local notification = require('tensor-theme.notification')

local module = {}

function module.init()
  beautiful.init(string.format('%s/.config/awesome/tensor-theme/theme.lua', os.getenv('HOME')))
  rules.init()
  keys.init()
  signals.init()
  notification.init()
end

return module
