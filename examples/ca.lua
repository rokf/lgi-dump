local lgi = require 'lgi'
local Gtk = lgi.Gtk
local GLib = lgi.GLib

local window, canvas

-- 3 bit binary look up table
local binary = {
  [0] = {0,0,0},
  [1] = {0,0,1},
  [2] = {0,1,0},
  [3] = {0,1,1},
  [4] = {1,0,0},
  [5] = {1,0,1},
  [6] = {1,1,0},
  [7] = {1,1,1}
}

-- automata rules
local rules = {
  [1] = 1,
  [4] = 1
}

-- output table
local output = {
  {0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,0} -- starting line
}

local function calculate_next()
  local last = output[#output]
  local new = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  for i=1,14 do
    for bk,bv in ipairs(binary) do
      if bv[1] == last[i] and bv[2] == last[i+1] and bv[3] == last[i+3] then
        print(bk,rules[bk])
        new[i+1] = rules[bk] or 0
      end
    end
  end
  table.insert(output,new)
end

canvas = Gtk.DrawingArea {
  expand = true
}

window = Gtk.Window {
  width_request = 300,
  height_request = 400,
  resizable = false,
  window_position = "CENTER",
  title = 'ca',
  canvas
}

local function draw_rule_rect(cr,x,y,v)
  if v == 1 then
    cr:set_source_rgb(0,0.8,0.90)
  else
    cr:set_source_rgb(0,0,0.05)
  end
  cr:rectangle(x,y,12,12)
  cr:fill()
end

local function draw_rule(cr,x,y,inp,outp)
  draw_rule_rect(cr,x,y,inp[1])
  draw_rule_rect(cr,x+12,y,inp[2])
  draw_rule_rect(cr,x+12,y+12,outp)
  draw_rule_rect(cr,x+24,y,inp[3])
end

local function draw_rule_grey(cr,x,y)
  cr:set_source_rgb(0.85,0.85,0.85)
  cr:rectangle(x,y,12,12)
  cr:rectangle(x+12,y,12,12)
  cr:rectangle(x+12,y+12,12,12) -- bottom
  cr:rectangle(x+24,y,12,12)
  cr:fill()
end

canvas.on_draw = function (_,cr)
  cr:set_source_rgb(0,0,0.05)
  cr:paint()
  -- header
  cr:rectangle(0,0,300,100)
  cr:set_source_rgb(1,1,1)
  cr:fill()
  -- rules
  local xpos, ypos= 30,20
  local rule_count = 0
  for i=0,7 do
    if rules[i] ~= nil then
      draw_rule(cr,xpos,ypos,binary[i],rules[i])
    else
      draw_rule_grey(cr,xpos,ypos)
    end
    rule_count = rule_count + 1
    xpos = xpos + 50
    if rule_count == 5 then
      ypos = ypos + 30
      xpos = 30
      rule_count = 0
    end
  end
  -- output
  for li,l in ipairs(output) do
    for vi,v in ipairs(l) do
      if v == 1 then
        cr:set_source_rgb(0,0.8,0.90)
      else
        cr:set_source_rgb(0.85,0.85,0.85)
      end
      cr:rectangle(10+(vi*16),120+(li*16),12,12)
      cr:fill()
    end
  end
end

local timer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 200, function ()
  if #output > 13 then table.remove(output,1) end
  calculate_next()
  canvas:queue_draw()
  return true
end)

function window.on_destroy()
  GLib.source_remove(timer)
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
