local lgi = require 'lgi'
local Gtk = lgi.Gtk

local vpos = 100
local vpos2 = 0
local space = 40

local points = {
  space,vpos,
  space*2,vpos + vpos2,
  space*3,vpos,
  space*4,vpos - vpos2,
  space*5,vpos,
  space*6,vpos + vpos2,
  space*7,vpos
}

local canvas = Gtk.DrawingArea {
  expand = true
}

function draw_curve(p,cr)
  cr:set_source_rgb(1,0,0)
  for i=1,(#p - (#p % 6)),4 do
    cr:move_to(p[i],p[i+1])
    cr:save()
    cr:new_sub_path()
    cr:arc(p[i+2], p[i+3], 5, 0, math.rad(360))
    cr:restore()
    cr:move_to(p[i],p[i+1])
    cr:curve_to(p[i],p[i+1],p[i+2],p[i+3],p[i+4],p[i+5])
  end
  cr:stroke()
end

function canvas:on_draw(cr)
  cr:set_source_rgb(0,0,0)
  cr:paint()
  cr.line_cap = 'ROUND'
  cr.line_width = 5
  draw_curve(points,cr)
  return true
end

local window = Gtk.Window {
  width_request = 600,
  height_request = 400,
  title = 'Curve',
  Gtk.Box {
    canvas,
    Gtk.VScale {
      margin = 20,
      draw_value = false,
      adjustment = Gtk.Adjustment {
        lower = -50,
	    upper = 50,
	    step_increment = 1,
      },
      on_change_value = function (_,_,val)
        vpos2 = math.floor(val)
        points = {
          space,vpos,
          space*2,vpos + vpos2,
          space*3,vpos,
          space*4,vpos - vpos2,
          space*5,vpos,
          space*6,vpos + vpos2,
          space*7,vpos
        }
        canvas:queue_draw()
      end
    }
  }
}

function window:on_destroy()
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
