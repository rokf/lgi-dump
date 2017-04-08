local lgi = require 'lgi'
local Gtk = lgi.Gtk
local GLib = lgi.GLib

local progressbar = Gtk.ProgressBar {
  margin = 20,
  pulse_step = 0.1
}

local window = Gtk.Window {
  width_request = 500,
  height_request = 400,
  title = 'Progress',
  Gtk.Box {
    halign = 'CENTER',
    valign = 'CENTER',
    orientation = 'VERTICAL',
    Gtk.ToggleButton {
      label = 'Invert',
      on_toggled = function (_)
        progressbar.inverted = not progressbar.inverted
      end
    },
    progressbar
  }
}

local timer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, function ()
  progressbar:pulse()
  return true
end)

function window:on_destroy()
  GLib.source_remove(timer)
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
