local lgi = require 'lgi'
local Gtk = lgi.Gtk

local window

local infobar = Gtk.InfoBar {
  message_type = 'INFO',
  show_close_button = true,
  on_response = function (infobar,response_id)
    infobar:hide()
  end
}

infobar:get_content_area():add(Gtk.Label {
  id = 'infobar_label',
  label = 'INFO'
})

local combobox = Gtk.ComboBoxText {
  margin = 20,
  on_changed = function (combobox)
    infobar:show_all()
    local text = combobox:get_active_text()
    infobar.message_type = text
    window.child.infobar_label.label = 'Current message_type is ' .. text
  end
}

for _,v in ipairs({'INFO','WARNING','QUESTION','ERROR','OTHER'}) do
  combobox:append_text(v)
end

window = Gtk.Window {
  width_request = 500,
  height_request = 400,
  title = 'Info',
  Gtk.Box {
    orientation = 'VERTICAL',
    infobar,
    combobox
  }
}

function window:on_destroy()
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
