local lgi = require 'lgi'
local Gtk = lgi.Gtk

local stack = Gtk.Stack {
  transition_type = 'SLIDE_UP',
  transition_duration = 500
}

stack:add_titled(Gtk.Box {
  Gtk.Label { label = 'Child 1', margin = 20 }
}, "child1", "Child 1")

stack:add_titled(Gtk.Box {
  Gtk.Label { label = 'Child 2', margin = 20 }
}, "child2", "Child 2")

stack:add_titled(Gtk.Box {
  Gtk.Button {
    label = 'Child 3',
    margin = 20,
    on_clicked = function (_)
      stack.visible_child_name = 'child1'
    end
  }
}, "child3", "Child 3")

local headerbar = Gtk.HeaderBar {
  show_close_button = true,
  custom_title = Gtk.StackSwitcher {
    stack = stack
  }
}

local window = Gtk.Window {
  width_request = 400,
  height_request = 400,
  Gtk.Box {
    orientation = 'HORIZONTAL',
    Gtk.StackSidebar {
      stack = stack
    },
    stack
  }
}

function window:on_destroy()
  Gtk.main_quit()
end

window:set_titlebar(headerbar)

window:show_all()
Gtk:main()
