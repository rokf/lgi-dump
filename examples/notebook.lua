local lgi = require 'lgi'
local Gtk = lgi.Gtk

local notebook = Gtk.Notebook {
  show_border = false,
  enable_popup = true,
}

notebook:append_page(Gtk.Box {
  Gtk.Label {
    margin = 20,
    label = 'Page 1'
  }
}, Gtk.Label {
  label = 'Page 1'
})

notebook:append_page(Gtk.Box {
  Gtk.Label {
    margin = 20,
    label = 'Page 2'
  }
}, Gtk.Image {
  icon_name = 'network-wireless-symbolic'
})

notebook:append_page(Gtk.Box {
  Gtk.Label {
    margin = 20,
    label = 'Page 3'
  }
}, Gtk.Label {
  label = 'Page 3'
})

local action_button = Gtk.EventBox {
  Gtk.Image { icon_name = 'go-next-symbolic' },
  margin_right = 5,
  on_button_press_event = function ()
    notebook:next_page()
  end
}

notebook:set_action_widget(action_button, 1)

action_button:show_all()

local window = Gtk.Window {
  width_request = 500,
  height_request = 400,
  title = 'Notebook',
  notebook
}

function window:on_destroy()
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
