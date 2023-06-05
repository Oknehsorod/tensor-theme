local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local module = {}

module.FONT = 'Inter 16'
module.FONT_MONO = 'Roboto 16'

module.PANEL_HEIGHT = dpi(48)
module.TITLEBAR_HEIGHT = dpi(36)

module.TERMINAL = 'terminator'

module.APPS = {
  {
    'pcmanfm',
  },
  {
    'terminator',
  },
  {
    'google-chrome',
  },
  {
    'slack',
    'telegram',
  },
}

module.CLIENT_RADIUS = dpi(10)

return module
