ncii
====

ii console client with curses UI written in perl.

Requires: libwww-perl, MIME::Base64, Curses::UI, YAML.

## Keybindings:

- C-n: next echo
- C-p: prev echo
- C-q: quit
- C-[: decrease echo list width
- C-]: increase echo list width
- Up, Down, PgUP, PgDown, Home, End: navigate message list or preview
- /: search (by title or in preview)
- Tab: switch between message list and preview

