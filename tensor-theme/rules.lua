local awful = require('awful')
local beautiful = require('beautiful')
local constants = require('tensor-theme.constants')
local gears = require('gears')

local module = {}

local clientbuttons = gears.table.join(awful.button({}, 1, function(c)
  c:emit_signal('request::activate', 'mouse_click', { raise = true })
end))

function module.init()
  awful.rules.rules = {
    -- All clients will match this rule.
    {
      rule = {},
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        floating = false,
        -- keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.focused,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        shape = function()
          return function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, constants.CLIENT_RADIUS)
          end
        end,
      },
    },
    {
      rule = { instance = 'guake' },
      properties = {
        floating = true,
        border_width = 0,
        titlebars_enabled = false,
        shape = function()
          return nil
        end,
      },
    },
    { rule_any = { type = { 'normal', 'dialog' } }, properties = { titlebars_enabled = true } },
  }

  for idx, instances in ipairs(constants.APPS) do
    table.insert(awful.rules.rules, {
      rule_any = { instance = instances },
      properties = {
        tag = tostring(idx),
      },
    })
  end
end

return module
