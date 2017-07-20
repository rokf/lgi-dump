local lgi = require 'lgi'
local Gtk = lgi.Gtk
local Gio = lgi.Gio
local Gdk = lgi.Gdk
local GLib = lgi.GLib

local app = Gtk.Application { application_id = 'org.lgi.notifications' }

function rgb_to_hex(rgb)
  return string.format("#%02x%02x%02x",math.floor(rgb.red*255),math.floor(rgb.green*255),math.floor(rgb.blue*255))
end

function app:on_activate()
  local fixed = Gtk.Fixed {}
  fixed:put(Gtk.Button {
    label = 'Notify',
    on_clicked = function (_)
      local notification = Gio.Notification.new('Example Notification')
      notification:set_body('This is a notification.')
      app:send_notification('norif-example',notification)
    end
  },5,5)
  fixed:put(Gtk.ColorButton {
    on_color_set = function (b)
      local notification = Gio.Notification.new('Color Selected')
      notification:set_body(rgb_to_hex(b.rgba))
      app:send_notification('norif-example',notification)
    end
  },5,40)

  local window = Gtk.Window {
    width_request = 300,
    height_request = 300,
    title = 'Notifications',
    application = self,
    fixed
  }
  window:show_all()
end


-- function window:on_destroy()
--   Gtk.main_quit()
-- end

-- window:show_all()
-- Gtk:main()

app:run { arg[0], ... }
