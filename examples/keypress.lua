local lgi = require 'lgi'
local Gtk = lgi.Gtk
local Gdk = lgi.Gdk

local entry = Gtk.Entry {
  placeholder_text = 'Type something and press Ctrl+M to move down'
}
local textview = Gtk.TextView { expand = true }
textview.buffer.text = 'Press Ctrl+E to clear'

local window = Gtk.Window {
  width_request = 500,
  height_request = 400,
  title = 'Keypress',
  Gtk.Box {
    margin = 5,
    orientation = 'VERTICAL',
    entry,
    Gtk.Frame {
      margin_top = 5,
      textview
    }
  }
}

function window:on_key_press_event(e)
  local ctrl_on = e.state.CONTROL_MASK
  local shift_on = e.state.SHIFT_MASK
  if e.keyval == Gdk.KEY_e and ctrl_on then
    textview.buffer.text = ''
  elseif e.keyval == Gdk.KEY_m and ctrl_on then
    textview.buffer.text = entry.text
    entry.text = ''
  else
    return false
  end
  return true
end

function window:on_destroy()
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
