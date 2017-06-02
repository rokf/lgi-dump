local lgi = require 'lgi'
local Gtk = lgi.Gtk

-- box-shadow: 0px -1px 2px -2px white;

local stylesheet = [[
  @define-color bg_color #FFE4E1;
  @define-color fg_color #2F4F4F;

  GtkHeaderBar {
	background: transparent;
    border-bottom-color: transparent;
    box-shadow: inset 0px 1px 2px -2px white;
  }

  GtkHeaderBar GtkLabel {
    color: @fg_color;
  }

  GtkWindow {
    background-color: @bg_color;
  }

  GtkTextView {
    background: transparent;
  }

  GtkTextView:selected {
    color: @bg_color;
    background-color: @fg_color;
  }
]]

local textview = Gtk.TextView {
  left_margin = 5,
  top_margin = 5,
  wrap_mode = 'WORD'
}

local cssprov = Gtk.CssProvider()
cssprov:load_from_data(stylesheet)

local header = Gtk.HeaderBar {
  show_close_button = true
}

header:pack_end(Gtk.Button {
  on_clicked = function (button)
    textview.buffer.text = ''
  end,
  Gtk.Image { icon_name = 'task-past-due-symbolic' }
})
header:pack_end(Gtk.Button { Gtk.Image { icon_name = 'mail-send-symbolic' } })

local window = Gtk.Window {
  width_request = 500,
  height_request = 400,
  title = 'Joined',
  resizable = false,
  Gtk.ScrolledWindow {
    textview
  }
}

window:set_titlebar(header)

function window:on_destroy()
  Gtk.main_quit()
end

local wsc = window:get_style_context()
wsc.add_provider_for_screen(window:get_screen(),cssprov,600)

window:show_all()
Gtk:main()
