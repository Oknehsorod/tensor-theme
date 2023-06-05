local xresources = require('beautiful.xresources')
local gears = require('gears')
local dpi = xresources.apply_dpi

local themes_path = string.format('%s/.config/awesome/tensor-theme/', os.getenv('HOME'))

local theme = {}

theme.font = 'Inter 16'

theme.bg_normal = '#FFFFFF'
theme.systray_icon_spacing = 5

-- theme.bg_normal     = gears.color({
--   type = "linear",
--   from = { 0, 0 },
--   to = { 0, dpi(50) },
--   stops = {
--     { 0, "#C9C9C9" },
--     { 0.25, "#FFFFFF" },
--     { 0.75, "#FFFFFF" },
--     { 1, "#C9C9C9" },
--   },
-- })
theme.bg_focus = '#C9C9C900'
theme.bg_urgent = '#ff000000'
theme.bg_minimize = '#444444'
theme.bg_systray = theme.bg_normal
theme.bg_systray = '#FFFFFF'

theme.fg_normal = '#111111'
theme.fg_focus = '#333333'
theme.fg_urgent = '#333333'
theme.fg_minimize = '#333333'

theme.useless_gap = 0
theme.border_width = dpi(2)
theme.border_normal = '#000000'
theme.border_focus = '#333333'
theme.border_marked = '#91231c'

theme.titlebar_fg = '#FFFFFF'
theme.titlebar_bg_focus = '#141414'
theme.titlebar_bg = '#777777'

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. 'submenu.png'
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

theme.notification_shape = function (cr, width, height)
    return gears.shape.rounded_rect(cr, width, height, dpi(8))
end
theme.notification_border_width = dpi(1)
theme.notification_border_color = '#91caff'
theme.notification_bg = '#e6f4ff'

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. 'icons/titlebar/close_normal.png'
theme.titlebar_close_button_focus = themes_path .. 'icons/titlebar/close_focus.png'

theme.titlebar_minimize_button_normal = themes_path .. 'icons/titlebar/minimize_normal.png'
theme.titlebar_minimize_button_focus = themes_path .. 'icons/titlebar/minimize_focus.png'

theme.titlebar_ontop_button_normal_inactive = themes_path .. 'icons/titlebar/ontop_normal_inactive.png'
theme.titlebar_ontop_button_focus_inactive = themes_path .. 'icons/titlebar/ontop_focus_inactive.png'
theme.titlebar_ontop_button_normal_active = themes_path .. 'icons/titlebar/ontop_normal_active.png'
theme.titlebar_ontop_button_focus_active = themes_path .. 'icons/titlebar/ontop_focus_active.png'

theme.titlebar_sticky_button_normal_inactive = themes_path .. 'icons/titlebar/sticky_normal_inactive.png'
theme.titlebar_sticky_button_focus_inactive = themes_path .. 'icons/titlebar/sticky_focus_inactive.png'
theme.titlebar_sticky_button_normal_active = themes_path .. 'icons/titlebar/sticky_normal_active.png'
theme.titlebar_sticky_button_focus_active = themes_path .. 'icons/titlebar/sticky_focus_active.png'

theme.titlebar_floating_button_normal_inactive = themes_path .. 'icons/titlebar/floating_normal_inactive.png'
theme.titlebar_floating_button_focus_inactive = themes_path .. 'icons/titlebar/floating_focus_inactive.png'
theme.titlebar_floating_button_normal_active = themes_path .. 'icons/titlebar/floating_normal_active.png'
theme.titlebar_floating_button_focus_active = themes_path .. 'icons/titlebar/floating_focus_active.png'

theme.titlebar_maximized_button_normal_inactive = themes_path .. 'icons/titlebar/maximized_normal_inactive.png'
theme.titlebar_maximized_button_focus_inactive = themes_path .. 'icons/titlebar/maximized_focus_inactive.png'
theme.titlebar_maximized_button_normal_active = themes_path .. 'icons/titlebar/maximized_normal_active.png'
theme.titlebar_maximized_button_focus_active = themes_path .. 'icons/titlebar/maximized_focus_active.png'

theme.wallpaper = os.getenv('HOME') .. '/Pictures/wallpaper.jpg'

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. 'icons/layouts/fairh.png'
theme.layout_fairv = themes_path .. 'icons/layouts/fairv.png'
theme.layout_floating = themes_path .. 'icons/layouts/floating.png'
theme.layout_magnifier = themes_path .. 'icons/layouts/magnifier.png'
theme.layout_max = themes_path .. 'icons/layouts/max.png'
theme.layout_fullscreen = themes_path .. 'icons/layouts/fullscreen.png'
theme.layout_tilebottom = themes_path .. 'icons/layouts/tilebottom.png'
theme.layout_tileleft = themes_path .. 'icons/layouts/tileleft.png'
theme.layout_tile = themes_path .. 'icons/layouts/tile.png'
theme.layout_tiletop = themes_path .. 'icons/layouts/tiletop.png'
theme.layout_spiral = themes_path .. 'icons/layouts/spiral.png'
theme.layout_dwindle = themes_path .. 'icons/layouts/dwindle.png'
theme.layout_cornernw = themes_path .. 'icons/layouts/cornernw.png'
theme.layout_cornerne = themes_path .. 'icons/layouts/cornerne.png'
theme.layout_cornersw = themes_path .. 'icons/layouts/cornersw.png'
theme.layout_cornerse = themes_path .. 'icons/layouts/cornerse.png'

-- Generate Awesome icon:
-- theme.awesome_icon = theme_assets.awesome_icon(
--     theme.menu_height, theme.bg_focus, theme.fg_focus
-- )

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Notification

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
