local websocket = require 'http.websocket' -- https://github.com/daurnimator/lua-http
local cqueues = require 'cqueues'
local lgi = require 'lgi'
local Gtk = lgi.Gtk
local GLib = lgi.GLib

local timer

local listbox = Gtk.ListBox {
  expand = true
}

local ws = websocket.new_from_uri("wss://echo.websocket.org")
ws:connect()

local entry = Gtk.Entry {
  placeholder_text = 'Message',
  margin = 5,
  on_activate = function (e)
    ws:send(e.text)
    e.text = ""
  end
}

local window = Gtk.Window {
  width_request = 500,
  height_request = 400,
  title = 'Echo',
  Gtk.Box {
    orientation = 'VERTICAL',
    Gtk.ScrolledWindow {
      listbox
    },
    entry
  }
}

function window:on_show()
  local cq = cqueues.new()
  cq:wrap(function ()
    while true do
      local txt, opcode = ws:receive()
      if txt then
        listbox:insert(Gtk.Label {
          label = txt
        },-1)
        listbox:show_all()
      end
    end
  end)
  timer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, function()
    cq:step(0)
    return true
  end)
end

function window:on_destroy()
  GLib.source_remove(timer)
  ws:close()
  Gtk.main_quit()
end

window:show_all()
Gtk:main()
