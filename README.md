ncii
====

ii console client with curses UI written in perl.

Requires: libwww-perl, MIME::Base64, Curses::UI, YAML.

## Keybindings:

- C-n: next subscription
- C-p: prev subscription
- C-q: quit
- C-[: decrease echo list width
- C-]: increase echo list width
- Up, Down, PgUP, PgDown, Home, End: navigate message list or preview
- /: search (by title or in preview)
- Tab: switch between message list and preview

## Config

is located in file $HOME/.config/ncii/ncii.yaml

YAML syntax.

Key options:
- node: ii node URL, string
- echoes: subscriptions, array
