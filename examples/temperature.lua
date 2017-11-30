local lgi = require 'lgi'
local Gtk = lgi.Gtk
local GLib = lgi.GLib
local Gdk = lgi.Gdk
local cairo = lgi.cairo

local location = "/sys/class/thermal/thermal_zone0/temp"

local zone = string.match(location,"thermal_zone(%d)")
print(zone)

local temp = 0

local canvas = Gtk.DrawingArea({
  expand = true,
  on_draw = function (self,cr)
    -- background
    cr:set_source_rgb(1,1,1)
    cr:paint()
    -- temp rect
    cr:set_source_rgb(1,0,0)
    local rect = Gdk.Rectangle {
      x = 95,
      y = 250,
      width = 10,
      height = - temp
    }
    cr:rectangle(rect)
    cr:fill()
    -- thermal zone header
    cr:set_source_rgb(0,0,0)
    local zrect = Gdk.Rectangle {
      x = 0,
      y = 50,
      height = 30,
      width= 200
    }
    cr:rectangle(zrect)
    cr:fill()
    cr:select_font_face('Sans', cairo.FontSlant.NORMAL, cairo.FontWeight.BOLD)
    cr:set_font_size(20)
    cr:set_source_rgb(1,1,1)
    local zone_txt = 'ZONE ' .. zone
    local zone_ex = cr:text_extents(zone_txt)
    cr:move_to(100-(zone_ex.width/2+zone_ex.x_bearing),65-(zone_ex.height/2+zone_ex.y_bearing))
    cr:show_text(zone_txt)
    -- scale
    cr:select_font_face('Sans', cairo.FontSlant.NORMAL, cairo.FontWeight.NORMAL)
    cr:set_font_size(10)
    cr:set_source_rgb(0,0,0)
    for i=250,150,-20 do
      local txt = tostring((i-250)*(-1))
      local ex = cr:text_extents(txt)
      cr:move_to(80,i-(ex.height/2+ex.y_bearing))
      cr:show_text(txt)
    end
    -- temperature label
    cr:select_font_face('Sans', cairo.FontSlant.NORMAL, cairo.FontWeight.BOLD)
    cr:set_font_size(13)
    local ex = cr:text_extents(tostring(temp) .. '°C')
    cr:move_to(100-(ex.width/2+ex.x_bearing),270)
    cr:set_source_rgb(0,0,0)
    cr:show_text(tostring(temp) .. '°C')
  end
})

local window = Gtk.Window {
  width_request = 200,
  height_request = 300,
  title = 'Temperature',
  resizable = false,
  canvas
}

local timer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 512, function ()
  local file = io.open(location,"r")
  temp = file:read("*number")/1000
  file:close()
  canvas:queue_draw()
  return true
end)

function window:on_destroy()
  GLib.source_remove(timer)
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
