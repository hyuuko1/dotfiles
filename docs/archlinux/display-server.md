- [Xorg, X11, Wayland? Linux Display Servers And Protocols Explained](https://linuxiac.com/xorg-x11-wayland-linux-display-servers-and-protocols-explained/)

X.Org server is the free and open-source implementation of the X Window System display server stewarded by the X.Org Foundation. It is an application that interacts with client applications via the X11 protocol to draw things on display and to send input events like mouse movements, clicks, and keystrokes. Typically, one would start an X server which will wait for client’s applications to connect to it. However, Xorg is based on a client/server model and thus allows clients to run either locally or remotely on a different machine.

X11 is a network protocol. It describes how messages are exchanged between a client (application) and the display server.

Wayland is a communication protocol that specifies the communication between a display server and its clients.
Wayland is developed as a free and open-source community-driven project to replace the X Window System (also known as X11 or Xorg ) with a modern, secure, and more straightforward windowing system.

In Wayland, the compositor is the display server. The compositor is a window manager that provides applications with an off-screen buffer for each window. The window manager composites the window buffers into an image representing the screen and writes the result into the display memory.

The Wayland protocol lets the compositor send the input events directly to the clients and enables the client to send the damage event directly to the compositor.

As in the X case, when the client receives the event, it updates the user interface (UI). But in the Wayland rendering happens in the client, so the client sends a request to the compositor to indicate the region that was updated.

Wayland’s main advantage over X is that it starts from scratch. One of the main reasons for X’s complexity is that, over the years, its role has changed. As a result, today, X11 acts largely as “a really terrible” communications protocol between the client and the window manager.

Wayland is also superior when it comes to security. With X11, it’s possible to do something known as “keylogging” by allowing any program to exist in the background and read what’s happening with other windows open in the X11 area.

This simply won’t happen with Wayland, as each program works independently.

总结：

- communication protocol 是用于在 client 和 display server 之间通信的
- X11 和 Wayland 都是 communication protocol
  - X11 的 display server 是 X.Org server
  - Wayland 的 display server 是 compositor (a window manager, 比如 kwin？)
