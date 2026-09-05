# Zellij Cheatsheet

Zellij uses modes instead of a prefix key. Press the mode key, perform an
action, then Zellij returns to normal mode. The status bar always shows the
available keys for the active mode.

## Everyday workflow

| Action | Shortcut |
| --- | --- |
| Open the pane mode | `Ctrl-p` |
| Open the tab mode | `Ctrl-t` |
| Open the resize mode | `Ctrl-n` |
| Enter scrollback mode | `Ctrl-s` |
| Lock or unlock Zellij shortcuts | `Ctrl-g` |
| Create a new pane immediately | `Alt-n` |
| Focus a neighboring pane | `Alt-h`, `Alt-j`, `Alt-k`, `Alt-l` |
| Toggle the focused pane fullscreen | `Alt-f` |
| Increase or decrease pane size | `Alt-=` / `Alt--` |
| Move to the next or previous tab when at a pane edge | `Alt-Right` / `Alt-Left` |

## Panes and tabs

1. Press `Ctrl-p` for pane actions. Use the visible hints to split, close,
   rename, float, or fullscreen the focused pane.
2. Press `Ctrl-t` for tab actions. Use its visible hints to create, close,
   rename, reorder, and switch tabs.
3. Use `Alt-h/j/k/l` for fast focus changes without entering a mode.
4. Use `Ctrl-s` to inspect scrollback. Press `Ctrl-c` to return to the bottom
   and normal mode.

## Sessions

The shell starts or attaches to the `main` session automatically.

```sh
zellij list-sessions
zellij attach main
zellij attach --create project-name
zellij delete-session project-name
```

Use a named session per long-running project. Press `Ctrl-o`, then `d` to
detach; the session-mode hints cover the remaining session actions.

## Working ergonomically

- Keep one task per tab and split only when two programs must be visible.
- Use `Alt-f` instead of closing surrounding panes when you need focus.
- Lock shortcuts with `Ctrl-g` before using terminal applications that need
  control-key combinations; press it again to unlock.
- The status bar is contextual documentation: open a mode first instead of
  memorizing every action.
