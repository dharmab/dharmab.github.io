---
layout: post
title: Please Don't Use Arch Linux Without Regular Upgrades
categories: linux
---

Sometimes I encounter people who suggest the use of Arch Linux in situations where regular upgrades are not available (either because internet access is limited, or because the user is not willing to run regular upgrades). In these situations, Arch Linux is not a good choice. Arch virtually requires regular upgrades and an internet connection as a consequence of the following two facts:

## Fact 1:
[Partial upgrades are unsupported](https://wiki.archlinux.org/index.php/Pacman#Partial_upgrades_are_unsupported). This means that if a new version of your favorite application comes out, you can't just upgrade that package- or rather, you can try, but you risk breaking dependencies. Instead, you have to upgrade every package on the system with `pacman -Syu`.

## Fact 2:
While Pacman is fantastic at automating most of the upgrade work, manual intervention is required quite often. Some examples since March (under 4 months ago!):

* [MySQL was completely replaced with MariaDB](https://www.archlinux.org/news/mariadb-replaces-mysql-in-repositories/)

* The infamous [move to /use/bin for all binaries](https://www.archlinux.org/news/binaries-move-to-usrbin-requiring-update-intervention/)

* [A TeXLive upgrade that required user intervention to overwrite configuration files](https://www.archlinux.org/news/texlive-2013-update-may-require-user-intervention/)

* [Deprecation of /etc/sysctl.conf, requiring users who used this for hardware configuration to move their settings into /etc/sysctl.d](https://www.archlinux.org/news/deprecation-of-etcsysctlconf/)

* [A kernel change that leaves some users without keyboard unless they add the module in question to their mkiitcpio.conf](https://www.archlinux.org/news/deprecation-of-etcsysctlconf/)

* Not [one](https://www.archlinux.org/news/screen-420-cannot-reattach-older-instances/), but [two](https://www.archlinux.org/news/screen-421-cannot-reattach-older-instances-either/) upgrades that brok existing instances of screen

That's not even including new versions of Qt and Perl that may require some packages to be rebuilt, and a change to how Haskell packages are managed in Arch.

A user who doesn't upgrade for months at a time will have a laundry list of manual interventions to read and attempt. If they go for too long, there is no guarantee that a simple upgrade path will exist (e.g. attempting to upgrade from initscripts to systemd after the transition period). Since partial upgrades are unsupported, they won't be able to only upgrade one or two packages that they need.

I love Arch Linux, but for this use case it's not the right choice. My personal choice would be Debian Stable, but there are lots of other great options. Just please, don't use Arch without internet.
