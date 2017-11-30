
local lgi = require 'lgi'
local cairo = lgi.cairo

-- create surface and context
-- fill the surface with white background
local surface = cairo.SvgSurface.create("svg_export_example.svg",256,256)
local context = cairo.Context.create(surface)
context:set_source_rgb(1,1,1)
context:paint()

-- font setup
context:select_font_face('Sans', cairo.FontSlant.NORMAL, cairo.FontWeight.BOLD)
context:set_font_size(20)
context:set_source_rgb(0,0,0)

-- get extents
local text = "SVG EXPORT"
local extents = context:text_extents(text)

-- write the text
context:move_to(128-(extents.width/2+extents.x_bearing),128-(extents.height/2+extents.y_bearing))
context:show_text(text)

-- finish
surface:flush()
surface:finish()

-- now a svg file with the name svg_export_example.svg should be created
-- size 256x256px
