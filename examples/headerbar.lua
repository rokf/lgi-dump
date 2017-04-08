
local lgi = require 'lgi'
local Gtk = lgi.Gtk
local Gdk = lgi.Gdk

local color = Gdk.RGBA {
  red = 1,
  green = 1,
  blue = 1,
  alpha = 1
}

local drawing_area = Gtk.DrawingArea {}

function drawing_area:on_draw(cr)
  cr:set_source_rgba(color)
  cr:paint()
  return true
end

local headerbar = Gtk.HeaderBar {
  title = 'HeaderBar',
  subtitle = 'Example',
  show_close_button = true
}

headerbar:pack_start(Gtk.ColorButton {
  rgba = color,
  on_color_set = function (button)
    color = button.rgba
  end
},false,false,0)

headerbar:pack_end(Gtk.ToolButton {
  icon_name = 'document-properties'
},false,false,0)


local window = Gtk.Window {
  width_request = 400,
  height_request = 400,
  drawing_area
}

window:set_titlebar(headerbar)

function window:on_destroy()
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
