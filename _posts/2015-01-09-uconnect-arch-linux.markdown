---
layout: post
title: How to Connect to University of Utah UConnect Wifi with Arch Linux and netctl
categories: archlinux linux
---

Here's a netctl profile to connect to the University of Utah's UConnect wifi network.

    Description='University of Utah UConnect'
    Interface=wlan0
    Connection=wireless
    Security=wpa-configsection
    IP=dhcp
    IP6=stateless
    WPAConfigSection=(
        'ssid="UConnect"'
        'key_mgmt=WPA-EAP'
        'eap=PEAP'
        'anonymous_identity="anonymous"'
        'identity="u0123456"'
        'password="password"'
        'phase2="auth=MSCHAPV2"'
        'ca_cert="/etc/ssl/certs/AddTrust_External_Root.pem"'
    )

Replace `Interface` with your wireless interface (probably some sort of persistent udev name like `wlp3s0`), `identity` with your uID and `password` with the same password you use for CIS, UMail, etc.

Note that UConnect uses MSCHAPv2 authentication, [which is not considered secure](https://wiki.archlinux.org/index.php/WPA2_Enterprise#MS-CHAPv2). I highly encourage using a private or commercial VPN service while using UConnect- you could manage your own VPN server running in the cloud, or use one of the commercial services cataloged by TorrentFreak ([2014 edition here](http://torrentfreak.com/which-vpn-services-take-your-anonymity-seriously-2014-edition-140315/), 2015 update coming soon).

Thanks to the Virginia Tech Linux and Unix Users Group, which has a number of sample configurations on [their PEAP-MSCHAP wiki page](https://vtluug.org/wiki/PEAP-MSCHAP). I also used information from [UIT's knowledge base article on UConnect](https://uofu.service-now.com/cf/kb_view.do?sysparm_article=KB0000928).
