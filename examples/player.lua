local lgi = require 'lgi'
local Gtk = lgi.Gtk
local Gdk = lgi.Gdk
local GLib = lgi.GLib

local window
local data = {20,10,30,50,40,20}

local pause = false

local bar = Gtk.ActionBar {}
bar:pack_start(Gtk.Button {
  Gtk.Image {
    icon_name = 'media-playback-start-symbolic'
  },
  on_clicked = function (_)
    pause = false
  end
}, false,false,0)

bar:pack_start(Gtk.Button {
  Gtk.Image {
    icon_name = 'media-playback-pause-symbolic'
  },
  on_clicked = function (_)
    pause = true
  end
}, false,false,0)

local canvas = Gtk.DrawingArea {
  expand = true
}

function draw_data(data,cr)
  local col_width = (canvas.width - 50) / 30
  for i=1,#data do
    cr:set_source_rgb(0,1,0)
    local rect = Gdk.Rectangle {
      x = 10+(i*col_width),
      y = canvas.height/2,
      width = col_width,
      height = -data[i]
    }

    cr:rectangle(rect)
    cr:fill()
  end
end

function canvas:on_draw(cr)
  cr:set_source_rgb(0,0,0)
  cr:paint()
  draw_data(data,cr)
  return true
end

local timer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 200, function ()
  if not pause then
    for i=1, 30 do
      data[i] = math.random(0,30)
    end
    canvas:queue_draw()
  end
  return true
end)

window = Gtk.Window {
  width_request = 500,
  height_request = 400,
  title = 'Player',
  Gtk.Box {
    orientation = 'VERTICAL',
    canvas,
    bar
  }
}

function window:on_destroy()
  GLib.source_remove(timer)
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
