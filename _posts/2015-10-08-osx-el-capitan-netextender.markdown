---
layout: post
title: Dell SonicWall NetExtender on OSX 10.11 El Capitan
categories: fuck dell
---

Dell SonicWall NetExtender 8.0.785 is broken on OSX 10.11 El Capitan. Here's why it's broken and how to fix it.

OSX 10.11 adds a security feature called System Integrity Protection, or SIP. Simply put, Administrator (root) accounts no longer have full system accesss by default. NetExtender needs to access the system network devices the first time you connect to a VPN and silently crashes when it can't do this in El Capitan.

The fix is quick and simple: temporarily disable SIP, connect with NetExtender once, and reenable SIP. Total time: about ten minutes.

1. Unmute your sound so you can hear the boot sounds in later steps.
1. Reboot your Mac.
1. When you hear the classic Mac startup sound, hit `cmd`+`r` to enter recovery mode. The boot progress should take significantly longer than normal. If you see the login screen, restart and try again.
1. In recovery mode, click Utilities > Terminal.
1. Type `csrutil disable` and reboot to disable SIP.
1. Install NetExtender, open the app and connect once. You should be prompted for the admin password- this will modify the network interfaces.
1. After successfully connecting once, reboot and enter recovery mode again.
1. Open the terminal again, type `csrutil enable` and reboot to enable SIP.
1. Test the NetExtender again and verify that your connection works with SIP enabled.
