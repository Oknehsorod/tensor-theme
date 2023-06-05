local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local inspect = require('inspect.inspect')
local naughty = require('naughty')
local wibox = require('wibox')
local xresources = require('beautiful.xresources')

local dpi = xresources.apply_dpi

local module = {
  icon = {},
}

local function get_icons_folder()
  return string.format('%s/.config/awesome/tensor-theme/icons', os.getenv('HOME'))
end

function module.icon.get_tag_icon(index)
  return string.format('%s/tag-icons/tag-%s.png', get_icons_folder(), index)
end

function module.icon.get_selected_tag_icon(index)
  return string.format('%s/tag-selected-icons/tag-selected-%s.png', get_icons_folder(), index)
end

function module.icon.get_windows_tag_icon(index)
  return string.format('%s/tag-windows-icons/tag-windows-%s.png', get_icons_folder(), index)
end

function module.icon.get_urgent_windows_tag_icon(index)
  return string.format('%s/tag-urgent-window-icons/%s.png', get_icons_folder(), index)
end

function print(value)
  naughty.notify({ font = 'Inter 8',text = inspect(value, { depth = 2 }), timeout = 10000 })
end

function module.m(widget, ml, mr, mb, mt)
  return wibox.container.margin(widget, dpi(ml or 0), dpi(mr or 0), dpi(mt or 5), dpi(mb or 5))
end

function module.to_fixed(num)
  return string.format('%.2f', num)
end

function module.get_fixed_str(str, min_length)
  local missing_symbols_counter = min_length - #str

  if missing_symbols_counter <= 0 then
    return str
  end

  return string.rep(' ', missing_symbols_counter) .. str
end

function module.get_clients(tag)
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

function module.set_wallpaper(s)
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

function module.generate_tags(screen)
  for i = 1, 5, 1 do
    awful.tag.add(tostring(i), {
      icon = module.icon.get_tag_icon(i),
      layout = awful.layout.suit.tile,
      master_fill_policy = 'master_width_factor',
      gap_single_client = true,
      gap = 0,
      screen = screen,
      selected = i == 3,
    })
  end
end

function module.update_tag(_, tag, index)
  local clients_for_this_tag = module.get_clients(tag)
  local has_clients = #clients_for_this_tag.clients > 0
  local has_urgent_clients = clients_for_this_tag.has_urgent

  if tag.selected then
    tag.icon = module.icon.get_selected_tag_icon(index)
  elseif has_urgent_clients then
    tag.icon = module.icon.get_urgent_windows_tag_icon(index)
  elseif has_clients then
    tag.icon = module.icon.get_windows_tag_icon(index)
  else
    tag.icon = module.icon.get_tag_icon(index)
  end
end

return module
