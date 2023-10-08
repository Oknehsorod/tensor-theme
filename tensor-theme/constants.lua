local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local module = {}

module.FONT = 'Inter 12'
module.FONT_MONO = 'Roboto 12'

module.PANEL_HEIGHT = dpi(40)
module.TITLEBAR_HEIGHT = dpi(30)

module.TERMINAL = 'terminator'

module.APPS = {
  {},
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
  {
    'DBeaver',
    'postman',
  },
}

module.GPU_TEMP_COMMAND = 'nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader'

module.CLIENT_RADIUS = dpi(10)

return module
