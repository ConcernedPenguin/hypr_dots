from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class pywal(ColorScheme):
    progress_bar_color = 4

    def use(self, context):
        fg = default
        bg = default
        attr = normal

        if context.reset:
            pass
        elif context.directory:
            fg = blue
            attr = bold
        elif context.executable:
            fg = green
            attr = bold
        elif context.link:
            fg = cyan
        elif context.marked:
            fg = yellow
            attr = bold
        elif context.tag_marker:
            fg = red
            attr = bold
        elif context.selected:
            fg = white
            bg = magenta
            attr = bold
        elif context.error:
            fg = red
            attr = bold
        elif context.media:
            fg = magenta
        elif context.main_column:
            fg = white
        elif context.badinfo:
            fg = red

        return fg, bg, attr

