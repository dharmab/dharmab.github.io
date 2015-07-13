## dharmab.github.io

This is the source for my [GitHub Pages](https://pages.github.com) website. It runs on [Jekyll](https://www.jekyllrb.com).

### Vagrant

Because Ruby and Jekyll are quite complex to set up, I have included a Vagrantfile to automate the development environment. This is especially helpful on Windows. If you find this useful for creating your own websites, you are free to use it for your own projects.

1. Install [VirtualBox](https://www.virtualbox.org)
1. Install [Vagrant](https://www.vagrantup.com)
1. Open a shell
1. *Optional but recommended*: Install vagrant-vbguest with `vagrant plugin install vagrant-vbguest`. This can resolve some issues with VirtualBox
1. Change to the project directory (the directory that contains this file)
1. Start Vagrant with `vagrant up`. This will automatically download a Linux virtual machine, install Ruby and Jekyll and set up port forwarding
1. Enter the virtual machine with `vagrant ssh`
1. Within the virtual machine, change to the project directory with `cd /vagrant`
1. Type `jekyll serve --host 0.0.0.0`
1. Open a web browser and go to [http://localhost:4000](http://localhost:4000)

You can edit the website with your favorite editor and changes will automatically be loaded when you refresh the browser.
