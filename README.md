ncii
====

ii console client with curses UI written in perl.

Requires: libwww-perl, MIME::Base64, Curses::UI, YAML.

## Keybindings:

- C-n: next subscription
- C-p: prev subscription
- C-q: quit
- C-k: decrease echo list width
- C-l: increase echo list width
- C-f: fetch new messages
- Up, Down, PgUP, PgDown, Home, End: navigate message list or preview
- /: search (by title or in preview)
- Tab: switch between message list and preview
- n: New message
- r: Reply
- C-e: external editor (when composing message)
- C-s: queue message (when composing message)
- C-q: cancel message (when composing message)

## Config

NCII looks for config file named ncii.yaml first in wokkdir, then in $HOME/.config/ncii/
Also, first argument is treated as config file path. E.g. ncii myconfig1.yaml.

YAML syntax.

Key options:
- node: ii node URL, string
- echoes: subscriptions, array

# License

This project is licensed under the terms of BSD license. See LICENSE for details.
