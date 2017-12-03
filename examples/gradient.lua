local lgi = require 'lgi'
local cairo = lgi.cairo
local GLib = lgi.GLib
local Gtk = lgi.Gtk

math.randomseed(os.time())

local canvas = Gtk.DrawingArea {
  expand = true
}

local window = Gtk.Window {
  width_request = 500,
  height_request = 400,
  title = 'gradient',
  resizable = false,
  canvas
}

local c1,c2,c3 = 1,1,1
local position = 0
local step = 0.01

local rotc = 0
local rotstep = 0.01

function canvas.on_draw(_,cr)
  -- linear pattern for the background
  local pat = cairo.Pattern.create_linear(0,0,0,400)
  pat:add_color_stop_rgb(0,c1,c2,c3)
  pat:add_color_stop_rgb(position,c2,c1,c3)
  pat:add_color_stop_rgb(1,c3,c2,c1)
  cr:set_source(pat)
  -- create a path made of two circles and some text
  cr:arc(250,200,40,0,2*math.pi)
  cr:arc(250 + (math.cos(rotc))*80,200 + (math.sin(rotc))*80,10,0,2*math.pi)
  cr:select_font_face('Sans', cairo.FontSlant.NORMAL, cairo.FontWeight.BOLD)
  cr:set_font_size(40)
  cr:move_to(10,50)
  cr:text_path(string.format("%.2f°",rotc * (180/math.pi)))
  -- draw only inside the path
  cr:clip()
  -- paint the background
  cr:paint()
end

local timer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 16, function ()
  position = position + step
  rotc = rotc + rotstep
  if rotc >= math.pi * 2 then rotc = 0 end
  if position >= 1 or position <= 0 then
    step = step * (-1)
    c1 = math.random()
    c2 = math.random()
    c3 = math.random()
  end
  canvas:queue_draw()
  return true
end)

function window.on_destroy()
  GLib.source_remove(timer)
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
