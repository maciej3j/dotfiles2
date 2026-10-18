# Zellij Cheatsheet

Zellij starts in **locked** mode (`default_mode "locked"`), so every key goes
straight to the focused program. Press `Ctrl-g` to unlock (enter normal mode);
press `Ctrl-g` again - or `Esc` / `Enter` from any mode - to lock it back.
While unlocked, a single key opens a mode and the status bar always shows the
keys available in that mode.

The `Alt-*` shortcuts work in both locked and normal mode, so you can do most
navigation without ever unlocking Zellij.

## Everyday workflow

| Action | Shortcut |
| --- | --- |
| Unlock / lock Zellij | `Ctrl-g` |
| Pane mode | `p` |
| Tab mode | `t` |
| Resize mode | `r` |
| Scrollback mode | `s` |
| Move mode | `m` |
| Session mode | `o` |
| Quit Zellij (when unlocked) | `Ctrl-q` |
| Create a new pane immediately | `Alt-n` |
| Focus a neighboring pane | `Alt-h`, `Alt-j`, `Alt-k`, `Alt-l` |
| Toggle floating panes | `Alt-f` |
| Increase or decrease pane size | `Alt-=` / `Alt--` |
| Move the current tab left / right | `Alt-i` / `Alt-o` |
| Next or previous swap layout | `Alt-]` / `Alt-[` |
| Move to the next or previous tab when at a pane edge | `Alt-Right` / `Alt-Left` |

## Panes and tabs

1. Press `p` for pane actions. Use the visible hints to split, close,
   rename, float, or fullscreen the focused pane.
2. Press `t` for tab actions. Use its visible hints to create, close,
   rename, reorder, and switch tabs.
3. Use `Alt-h/j/k/l` for fast focus changes without unlocking.
4. Press `s` to inspect scrollback. Press `Ctrl-c` to return to the bottom
   and lock Zellij again.

## Sessions

The shell starts a fresh Zellij session automatically (a random session name
such as `joyous-donkey`), unless `ZELLIJ_AUTO_ATTACH=true` is set, in which
case it attaches to the most recent session.

```sh
zellij list-sessions
zellij attach main
zellij attach --create project-name
zellij delete-session project-name
```

Use a named session per long-running project. Press `o`, then `d` to detach;
the session-mode hints cover the remaining session actions.

## Working ergonomically

- Keep one task per tab and split only when two programs must be visible.
- Zellij is locked by default, so terminal applications receive all keys as
  they are. Prefer the `Alt-*` shortcuts instead of unlocking.
- Unlock with `Ctrl-g` only when you need the single-key mode shortcuts, and
  press `Esc` (or `Ctrl-g`) to lock again.
- Use pane mode `f` to fullscreen the focused pane instead of closing the
  surrounding ones.
- The status bar is contextual documentation: open a mode first instead of
  memorizing every action.
