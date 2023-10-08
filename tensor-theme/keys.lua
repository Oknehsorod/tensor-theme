local awful = require('awful')
local constants = require('tensor-theme.constants')
local gears = require('gears')
local hotkeys_popup = require('awful.hotkeys_popup')
local menubar = require('menubar')
local utils = require('tensor-theme.utils')

local module = {}

local modkey = 'Mod4'
local altkey = 'Mod1'

local globalkeys = gears.table.join(
  awful.key({ altkey }, 'F4', function()
    local current_client = client.focus
    if current_client then
      current_client:kill()
    end
  end, { description = 'Kill current focused client.', group = 'client' }),
  awful.key({ altkey }, 'Tab', function()
    local tag = awful.screen.focused().selected_tags[1]
    if tag == nil then
      return
    end

    local client_idx_to_raise = 0
    local tag_clients = tag:clients()
    for i, c in ipairs(tag_clients) do
      if c.window == client.focus.window then
        client_idx_to_raise = (#tag_clients == i) and 1 or i + 1
        break
      end
    end
    local client_to_focus = tag_clients[client_idx_to_raise]
    client.focus = client_to_focus
    client_to_focus:raise()
  end, { description = 'Focus on next client of focused tag.', group = 'client' }),
  awful.key({ 'Shift', altkey }, 'Right', function()
    local tags = awful.screen.focused().tags
    local current_tag_idx = client.focus.first_tag.index
    local tag = tags[current_tag_idx + 1]

    if tag == nil then
      return
    end

    client.focus:move_to_tag(tag)
    tag:view_only()
  end, { description = 'Move focused client to next tag.', group = 'tag' }),
  awful.key({ 'Shift', altkey }, 'Left', function()
    local tags = awful.screen.focused().tags
    local current_tag_idx = client.focus.first_tag.index
    local tag = tags[current_tag_idx - 1]

    if tag == nil then
      return
    end

    client.focus:move_to_tag(tag)
    tag:view_only()
  end, { description = 'Move focused client to previous tag.', group = 'tag' }),
  awful.key({ 'Shift', modkey }, 'Right', function()
    client.focus:move_to_screen(client.focus.screen.index + 1)
  end, { description = 'Move current focused client to next screen.', group = 'screen' }),
  awful.key({ 'Shift', modkey }, 'Left', function()
    client.focus:move_to_screen(client.focus.screen.index - 1)
  end, { description = 'Move current focused client to previous screen.', group = 'screen' }),
  awful.key({ modkey, 'Control' }, 'Right', function()
    awful.screen.focus_relative(1)
  end, { description = 'focus the next screen', group = 'screen' }),
  awful.key({ modkey, 'Control' }, 'Left', function()
    awful.screen.focus_relative(-1)
  end, { description = 'focus the previous screen', group = 'screen' }),
  awful.key({}, 'Print', function()
    awful.spawn('flameshot gui')
  end),
  awful.key({ modkey }, 's', hotkeys_popup.show_help, { description = 'show help', group = 'awesome' }),
  awful.key({ modkey }, 'r', function()
    awful.screen.focused().ui_widgets.promptbox_widget:run()
  end, { description = 'run prompt', group = 'launcher' }),
  awful.key({ modkey }, 'Left', awful.tag.viewprev, { description = 'view previous', group = 'tag' }),
  awful.key({ modkey }, 'Right', awful.tag.viewnext, { description = 'view next', group = 'tag' }),
  awful.key({ modkey, 'Control' }, 'r', awesome.restart, { description = 'reload awesome', group = 'awesome' })
)

function module.init()
  root.keys(globalkeys)
  root.buttons(gears.table.join(awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))
end

return module
