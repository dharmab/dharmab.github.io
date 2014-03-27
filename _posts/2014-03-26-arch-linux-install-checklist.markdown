--
layout: post
title: Arch Linux Install Checklist
categories: linux
--
This is my Arch Linux installation checklist. I mostly use it as a quick reference during the rare cases I need to do a fresh install from scratch. **Do  not use this as a general installation guide!** Refer to the [Beginners' guide](https://wiki.archlinux.org/index.php/Beginners%27_guide) for a detailed step-vy-step walkthrough.

Basic System
##
1. Boot into the installer and establish network access
1. Partition the drive with `cgdisk`
1. Format the partitions with `mkfs.ext4`
1. If using swap, use `mkswap` and `swapon` to format and enable the swap paritions
1. Mount the root partion to `/mnt`
1. Create mount points under `/mnt` and mount partitions as necessary. If using boot, mount the EFI System Partition under /mnt/boot
1. Select mirrors in `/etc/pacman.d/mirrorlist`
1. Start the install process with `pacstrap -i /mnt base base-devel sudo vim wget curl rsync openssh git ifplugd expac pacserve ntp reflector`
1. Generate an fstab with `genfstab -p /mnt >> /mnt/etc/fstab`
1. Chroot in with `arch-chroot`
1. Set the hostname in `/etc/hostname`
1. Symlink the correct timezone from `/user/share/zoneinfo/` to `/etc/localtime`
1. Set the hardware clock to store UTC time with `hwclock --systohc --utc`
1. Uncomment `en_US.UTF-8` in `/etc/locale.gen`, run `locale-gen` and create `/etc/locale.conf` with content `LANG=en_US.UTF-8`
1. Write netctl profiles in `/etc/netctl` and enable `netctl-ifplugd@interface` and `netctl-auto@interface` services as appropriate
1. Enable the `pacserve` and `ntpd` services
1. Set the root password with `passwd`
1. Install a boot loader. [Syslinux](https://wiki.archlinux.org/index.php/Syslinux) for BIOS, [gummiboot](https://wiki.archlinux.org/index.php/Gummiboot) for UEFI, [GRUB 2](https://wiki.archlinux.org/index.php/GRUB) for complicated environments
1. Exit the chroot and recursively unmount the partitions.
1. Reboot into the new install
1. Create a personal account with `useradd -m -s /bin/bash -g users -G wheel myusername` and `passwd username`
1. Set up sudo with `visudo`
1. Log into the personal account and set up the home folder
1. Generate a mirrorlist with `reflector`
1. Build `cower` and `pacaur` from the AUR

Desktop or Laptop
##
1. Install `alsa-utils` and unmute sound with `alsamixer`
1. Install GUI packages: `xorg-server xorg-server-utils xorg-xinit mesa slim i3 lxappearance elementary-icon-theme gtk-theme-flatstudio xcursor-simpleandsoft archlinux-themes-slim ttf-dejavu ttf-droid ttf-inconsolata`
1. Install a video driver: `xf86-video-intel`, `xf86-video-nouveau`, `nvidia`, or `xf86-video-ati` as required
1. Enable the `slim` service and reboot
1. Install user packages: `chromium evince file-roller gimp libreoffice mumble openjdk openvpn pcmanfm python ruby sbcl texlive-most truecrypt virtualbox vlc xterm`, plus the latest versions of Sublime Text and IntelliJ IDEA from the AUR
