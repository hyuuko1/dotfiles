- [Fedora Linux - Wikipedia](https://en.wikipedia.org/wiki/Fedora_Linux)

- [The Wayland Protocol :: Fedora Docs](https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/Wayland/)

Since the release of Fedora 25, the operating system defaults to the Wayland display server protocol, which replaced the X Window System.

Wayland is enabled by default in the GNOME Desktop. You can choose to run GNOME in X11 by choosing the Gnome on xorg option in the session chooser on the login screen. Currently KDE still uses X11 and although there is a plasma-wayland session available, it is not considered stable or bugfree at this time.

```bash
# 查看是否是 wayland
❯ set | grep wayland
DESKTOP_SESSION=plasmawayland
WAYLAND_DISPLAY=wayland-0
XDG_SESSION_TYPE=wayland
```
