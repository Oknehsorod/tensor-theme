local awful = require('awful')
local beautiful = require('beautiful')
local lain = require('lain')
local wibox = require('wibox')
local markup = lain.util.markup

local xresources = require('beautiful.xresources')

local dpi = xresources.apply_dpi

local buttons = require('tensor-theme.buttons')
local constants = require('tensor-theme.constants')
local utils = require('tensor-theme.utils')

local module = {}

function module.create_panel(screen)
  utils.set_wallpaper(screen)
  utils.generate_tags(screen)

  local keyboard_widget = awful.widget.keyboardlayout()

  local clock_widget = utils.m(wibox.widget.textclock('%H:%M'), 0, 10)

  lain.widget.cal({
    attach_to = { clock_widget },
    notification_preset = {
      fg = '#FFFFFF',
      bg = '#111111',
      position = 'bottom_right',
    },
  })

  local separator_widget = wibox.widget.separator()
  separator_widget.orientation = 'vertical'
  separator_widget.color = '#111111'
  separator_widget.thickness = 1
  separator_widget.opacity = 1
  separator_widget.forced_width = dpi(1)
  separator_widget.forced_height = dpi(44)
  separator_widget = utils.m(separator_widget, 10, 10)

  local memory_widget = lain.widget.mem({
    settings = function()
      widget:set_markup(
        markup.font(beautiful.font, 'RAM: ')
          .. markup.font(
            'Roboto Mono 16',
            utils.get_fixed_str(utils.to_fixed(mem_now.used / 1024), 5)
              .. '/'
              .. math.floor(mem_now.total / 1024)
              .. 'GB'
          )
      )
    end,
  }).widget
  local cpu_widget = lain.widget.cpu({
    settings = function()
      widget:set_markup(
        markup.font(
          beautiful.font,
          'CPU: ' .. markup.font('Roboto Mono 16', utils.get_fixed_str(tostring(cpu_now.usage), 2)) .. '%'
        )
      )
    end,
  }).widget

  local taglist_widget = utils.m(
    awful.widget.taglist({
      screen = screen,
      filter = awful.widget.taglist.filter.all,
      widget_template = {
        {
          {
            id = 'icon_role',
            widget = wibox.widget.imagebox,
          },
          widget = wibox.container.margin,
          right = dpi(10),
        },
        id = 'background_role',
        widget = wibox.container.background,
        create_callback = utils.update_tag,
        update_callback = utils.update_tag,
      },
      buttons = buttons.get_taglist_buttons(),
    }),
    10
  )

  local layoutbox_widget = utils.m(awful.widget.layoutbox(screen), 0, 5, 5, 5)
  layoutbox_widget:buttons(buttons.get_layout_buttons())

  -- Create a tasklist widget
  local tasklist_widget = utils.m(
    awful.widget.tasklist({
      screen = screen,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = buttons.get_tasklist_buttons(),
      widget_template = {

        {
          {
            {
              id = 'icon_role',
              widget = wibox.widget.imagebox,
            },
            right = dpi(5),
            widget = wibox.container.margin,
          },
          {
            id = 'text_role',
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left = 0,
        right = dpi(30),
        widget = wibox.container.margin,
      },
    }),
    5
  )

  local systray_widget = wibox.widget.systray()
  systray_widget.forced_height = constants.PANEL_HEIGHT / 2
  -- systray_widget.forced_width = dpi(100)
  -- systray_widget.bg = '#FFFFFF'

  systray_widget = utils.m(systray_widget, 0, 5, 10, 10)

  local cpu_temp_widget = lain.widget.temp({
    settings = function()
      widget:set_markup(markup.font(beautiful.font, 'CPU: ' .. utils.get_integer_str(coretemp_now) .. '°'))
    end,
  }).widget

  local gpu_temp_widget = awful.widget.watch(constants.GPU_TEMP_COMMAND, 15, function(widget, stdout)
    widget:set_text('GPU: ' .. stdout:gsub('\n', '') .. '°')
  end)

  -- Create the wibox
  local main_container =
    awful.wibar({ position = 'bottom', screen = screen, height = constants.PANEL_HEIGHT, bg = '#FFFFFF' })

  screen.ui_widgets = {}
  screen.ui_widgets.promptbox_widget = awful.widget.prompt()
  main_container:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      taglist_widget,
      utils.m(separator_widget, -10, 0, 0, 0),
      layoutbox_widget,
      utils.m(separator_widget, -5, 0, 0, 0),
      screen.ui_widgets.promptbox_widget,
    },
    tasklist_widget, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      keyboard_widget,
      separator_widget,
      systray_widget,
      separator_widget,
      gpu_temp_widget,
      separator_widget,
      cpu_temp_widget,
      separator_widget,
      cpu_widget,
      separator_widget,
      memory_widget,
      separator_widget,
      clock_widget,
    },
  })
end

function module.create_titlebar(client)
  -- print(client.instance)
  if client.requests_no_titlebar then
    return
  end
  local titlebar = awful.titlebar(client, {
    size = constants.TITLEBAR_HEIGHT,
  })

  local title_widget = awful.titlebar.widget.titlewidget(client)
  title_widget.font = 'Inter 14'

  titlebar:setup({
    { -- Middle
      utils.m(title_widget, 15, 0, 5, 0),
      layout = wibox.layout.flex.horizontal,
    },
    {

      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      -- utils.m(awful.titlebar.widget.floatingbutton(client), 5, 5, 5, 5),
      utils.m(awful.titlebar.widget.maximizedbutton(client), 10, 5, 8, 8),
      utils.m(awful.titlebar.widget.closebutton(client), 10, 15, 8, 8),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  })
end

return module
