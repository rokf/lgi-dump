local lgi = require 'lgi'
local Gtk = lgi.Gtk

local stylesheet_template = [[
GtkLabel {
  color: %s;
}
GtkButton GtkLabel {
  color: %s;
}
]]

local cssprovider = Gtk.CssProvider()

local window = Gtk.Window {
  width_request = 500,
  height_request = 300,
  title = 'CSS',
  Gtk.Box {
    orientation = 'VERTICAL',
    Gtk.Label {
      margin = 20,
      label = 'Colored Gtk.Label'
    },
    Gtk.Button {
      margin = 20,
      label = 'Colored Gtk.Button',
      on_clicked = function (_)
        cssprovider:load_from_data(string.format(stylesheet_template, "red", "green"))
      end
    }
  }
}

local style_context = window:get_style_context()
style_context.add_provider_for_screen(window:get_screen(),cssprovider, 0)

function window:on_destroy()
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
