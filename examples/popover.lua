
local lgi = require 'lgi'
local Gtk = lgi.Gtk

local textview = Gtk.TextView {}

local popover

local popover_box = Gtk.Box {
  margin = 20,
  orientation = 'HORIZONTAL',
  Gtk.Entry {},
  Gtk.Button {
    label = 'Change'
  }
}

local popover_box_sc = popover_box:get_style_context()
popover_box_sc:add_class('linked')

local window = Gtk.Window {
  width_request = 350,
  height_request = 350,
  title = 'Popover',
  Gtk.Box {
    orientation = 'VERTICAL',
    halign = 'CENTER',
    valign = 'CENTER',
    Gtk.Frame {
      width = 200,
      height = 50,
      textview
    },
    Gtk.Button {
      height = 30,
      label = 'Click me!',
      on_clicked = function (button)
        local entry = Gtk.Entry {}
        local popover_box = Gtk.Box {
          margin = 20,
          orientation = 'HORIZONTAL',
          entry,
          Gtk.Button {
            label = 'Append',
            on_clicked = function (_)
              textview.buffer.text = textview.buffer.text .. entry.text
              entry.text = ''
              popover:hide()
            end
          }
        }

        local popover_box_sc = popover_box:get_style_context()
        popover_box_sc:add_class('linked')

        popover = Gtk.Popover {
          relative_to = button,
          popover_box
        }
        popover:show_all()
      end
    }
  }
}

function window:on_destroy()
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
