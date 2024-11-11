- [VMware vs KVM Hypervisors – Full Comparison](https://www.nakivo.com/blog/kvm-vs-vmware-performance-pricing-and-hardware-requirements/)

ArchWiki

- [Category:Virtualization - ArchWiki](https://wiki.archlinux.org/title/Category:Virtualization)
  - [systemd-nspawn - ArchWiki](https://wiki.archlinux.org/title/Systemd-nspawn)
  - [Linux Containers - ArchWiki](https://wiki.archlinux.org/title/Linux_Containers)
    Linux Containers (LXC) is an operating-system-level virtualization method for running multiple isolated Linux systems (containers) on a single control host (LXC host). It does not provide a virtual machine, but rather provides a virtual environment that has its own CPU, memory, block I/O, network, etc. space and the resource control mechanism. This is provided by the namespaces and cgroups features in the Linux kernel on the LXC host. It is similar to a chroot, but offers much more isolation.
    LXD can be used as manager for LXC.
    - [Linux Containers - LXD - Introduction](https://linuxcontainers.org/lxd/)
    - [LXD - ArchWiki](https://wiki.archlinux.org/title/LXD)
  - [Virt-Manager - ArchWiki](https://wiki.archlinux.org/title/Virt-Manager)
    Virt-Manager is a graphical user front end for the Libvirt library which provides virtual machine management services.
- [Category:Emulation - ArchWiki](https://wiki.archlinux.org/title/Category:Emulation)
  An emulator is an imitation of behavior of a computer or other electronic system with the help of another type of computer/system.
  - [QEMU - ArchWiki](https://wiki.archlinux.org/title/QEMU)
  - CrossOver
  - Wine
  - DOSBox

概念：hypervisors virtualization 等等

## virt-manager

/var/lib/libvirt/images/archlinux.qcow2

## QEMU

Libvirt provides a convenient way to manage QEMU virtual machines.

the hard disk image can be in a format such as qcow2 which only allocates space to the image file when the guest operating system actually writes to those sectors on its virtual hard disk. The image appears as the full size to the guest operating system, even though it may take up only a very small amount of space on the host system. This image format also supports QEMU snapshotting functionality. However, using this format instead of raw will likely affect performance.

```bash
# Create a hard disk image
qemu-img create -f raw|qcow2 image_file 4G

# Warning: If you store the hard disk images on a Btrfs file system, you should consider disabling Copy-on-Write for the directory before creating any images.
# 这里将原先的 /var/lib/libvirt/images/archlinux.qcow2 禁用 CoW
mv /var/lib/libvirt/images/archlinux.qcow2 /tmp/
chattr +C /var/lib/libvirt/images/
mv /tmp/archlinux.qcow2 /var/lib/libvirt/images/

# Warning: Resizing an image containing an NTFS boot file system could make the operating system installed on it unbootable.
qemu-img resize /var/lib/libvirt/images/archlinux.qcow2 +8G
# After enlarging the disk image, you must use file system and partitioning tools inside the virtual machine to actually begin using the new space.

cfdisk /dev/vda
resize2fs /dev/vda2

#  convert an image to other formats
qemu-img convert -f raw -O qcow2 input.img output.qcow2
```

```bash

sudo systemctl disable --now virtinterfaced-ro.socket virtinterfaced.socket virtinterfaced-admin.socket virtnetworkd-admin.socket virtnetworkd-ro.socket virtnetworkd.socket virtnodedevd.socket virtnodedevd-ro.socket virtnodedevd-admin.socket virtnwfilterd.socket virtnwfilterd-admin.socket virtnwfilterd-ro.socket virtqemud-ro.socket virtqemud.socket virtqemud-admin.socket virtsecretd.socket virtsecretd-ro.socket virtsecretd-admin.socket virtstoraged.socket virtstoraged-admin.socket virtstoraged-ro.socket virtinterfaced-ro.socket virtinterfaced.socket virtinterfaced-admin.socket virtnetworkd-admin.socket virtnetworkd-ro.socket virtnetworkd.socket virtnodedevd.socket virtnodedevd-ro.socket virtnodedevd-admin.socket virtnwfilterd.socket virtnwfilterd-admin.socket virtnwfilterd-ro.socket virtqemud-ro.socket virtqemud.socket virtqemud-admin.socket virtsecretd.socket virtsecretd-ro.socket virtsecretd-admin.socket virtstoraged.socket virtstoraged-admin.socket virtstoraged-ro.socket

```
