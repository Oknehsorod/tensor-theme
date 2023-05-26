local beautiful = require('beautiful')
local xresources = require('beautiful.xresources')

local awful = require('awful')
local gears = require('gears')
local lain = require('lain')
local wibox = require('wibox')
local markup = lain.util.markup

local inspect = require('inspect.inspect')
local naughty = require('naughty')

local dpi = xresources.apply_dpi

local theme = {}

local function print(value)
  naughty.notify({ title = 'DEBUG', text = inspect(value), timeout = 10000 })
end

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == 'function' then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

local function get_tag_icon(index)
  return string.format('%s/.config/awesome/theme/icons/tag-icons/tag-%s.png', os.getenv('HOME'), index)
end

local function get_selected_tag_icon(index)
  return string.format('%s/.config/awesome/theme/icons/tag-selected-icons/tag-selected-%s.png', os.getenv('HOME'), index)
end

local function get_separator_icon()
  return string.format('/%s/.config/awesome/theme/icons/separator.png', os.getenv('HOME'))
end

local function get_windows_tag_icon(index)
  return string.format('%s/.config/awesome/theme/icons/tag-windows-icons/tag-windows-%s.png', os.getenv('HOME'), index)
end

local function get_urgent_windows_tag_icon(index)
  return string.format('%s/.config/awesome/theme/icons/tag-urgent-window-icons/%s.png', os.getenv('HOME'), index)
end

local function m(widget, ml, mr, mb, mt)
  return wibox.container.margin(widget, dpi(ml or 0), dpi(mr or 0), dpi(mt or 5), dpi(mb or 5))
end

local function generate_tags(screen)
  for i = 1, 5, 1 do
    awful.tag.add('', {
      icon = get_tag_icon(i),
      layout = awful.layout.suit.tile,
      master_fill_policy = 'master_width_factor',
      gap_single_client = true,
      gap = 0,
      screen = screen,
      selected = i == 1,
    })
  end
end

local function get_clients(tag)
  local result = {
    has_urgent = false,
    clients = {},
  }

  for _, client in ipairs(client.get()) do
    if client.first_tag == tag then
      table.insert(result.clients, client)
      if client.urgent then
        result.has_urgent = true
      end
    end
  end

  return result
end

local function update_tag(_, tag, index)
  local clients_for_this_tag = get_clients(tag)
  local has_clients = #clients_for_this_tag.clients > 0
  local has_urgent_clients = clients_for_this_tag.has_urgent

  if tag.selected then
    tag.icon = get_selected_tag_icon(index)
  elseif has_urgent_clients then
    tag.icon = get_urgent_windows_tag_icon(index)
  elseif has_clients then
    tag.icon = get_windows_tag_icon(index)
  else
    tag.icon = get_tag_icon(index)
  end
end

local function get_tasklist_buttons()
  return gears.table.join(
    awful.button({}, 1, function(c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal('request::activate', 'tasklist', { raise = true })
      end
    end),
    awful.button({}, 3, function()
      awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
      awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
      awful.client.focus.byidx(-1)
    end)
  )
end

local function get_taglist_buttons()
  return gears.table.join(
    awful.button({}, 1, function(t)
      t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end),
    awful.button({}, 4, function(t)
      awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
      awful.tag.viewprev(t.screen)
    end)
  )
end

local function get_layout_buttons()
  return gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end)
  )
end

local function to_fixed(num)
  return string.format('%.2f', num)
end

local function get_fixed_str(str, min_length)
  local missing_symbols_counter = min_length - #str

  if missing_symbols_counter <= 0 then
    return str
  end

  return string.rep(' ', missing_symbols_counter) .. str
end

function theme.create_ui(screen)
  set_wallpaper(screen)
  generate_tags(screen)

  local keyboard_widget = awful.widget.keyboardlayout()

  local clock_widget = m(wibox.widget.textclock('%H:%M'), 0, 10)

  lain.widget.cal({
    attach_to = { clock_widget },
    notification_preset = {
      fg = '#FFFFFF',
      bg = '#111111',
      position = 'bottom_right',
    },
  })

  local separator_widget = m(wibox.widget.imagebox(get_separator_icon()), 10, 10)
  local memory_widget = lain.widget.mem({
    settings = function()
      widget:set_markup(
        markup.font(beautiful.font, 'RAM: ')
          .. markup.font(
            'Roboto Mono 14',
            get_fixed_str(to_fixed(mem_now.used / 1024), 5) .. '/' .. math.floor(mem_now.total / 1024) .. 'GB'
          )
      )
    end,
  }).widget
  local cpu_widget = lain.widget.cpu({
    settings = function()
      widget:set_markup(
        markup.font(
          beautiful.font,
          'CPU: ' .. markup.font('Roboto Mono 14', get_fixed_str(tostring(cpu_now.usage), 2)) .. '%'
        )
      )
    end,
  }).widget

  local taglist_widget = m(
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
        create_callback = update_tag,
        update_callback = update_tag,
      },
      buttons = get_taglist_buttons(),
    }),
    10
  )

  local layoutbox_widget = m(awful.widget.layoutbox(screen), 0, 5, 5, 5)
  layoutbox_widget:buttons(get_layout_buttons())

  -- Create a tasklist widget
  local tasklist_widget = m(
    awful.widget.tasklist({
      screen = screen,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = get_tasklist_buttons(),
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
  systray_widget:set_base_size(dpi(25))
  systray_widget = m(systray_widget, 0, 0, 5, 5)

  -- Create the wibox
  local main_container = awful.wibar({ position = 'bottom', screen = screen, height = dpi(35) })

  screen.ui_widgets = {}
  screen.ui_widgets.promptbox_widget = awful.widget.prompt()
  main_container:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      taglist_widget,
      m(separator_widget, -10, 0, 0, 0),
      layoutbox_widget,
      screen.ui_widgets.promptbox_widget,
    },
    tasklist_widget, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      keyboard_widget,
      separator_widget,
      systray_widget,
      separator_widget,
      cpu_widget,
      separator_widget,
      memory_widget,
      separator_widget,
      clock_widget,
    },
  })
end

function theme.create_titlebar(client)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      client:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.move(client)
    end),
    awful.button({}, 3, function()
      client:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.resize(client)
    end)
  )
  local titlebar = awful.titlebar(client, {
    size = dpi(30),
  })

  titlebar:setup({
    { -- Middle
      m(awful.titlebar.widget.titlewidget(client), 15, 0, 10, 5),
      layout = wibox.layout.flex.horizontal,
    },
    {

      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      m(awful.titlebar.widget.floatingbutton(client), 5, 5, 2, 2),
      m(awful.titlebar.widget.maximizedbutton(client), 5, 5, 5, 5),
      m(awful.titlebar.widget.closebutton(client), 5, 5, 5, 5),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  })
end

return theme
