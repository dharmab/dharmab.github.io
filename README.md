## dharmab.github.io

This is the source for my [GitHub Pages](https://pages.github.com) website. It runs on [Jekyll](https://www.jekyllrb.com).

### Have Ruby installed?

```bash
gem install bundler
bundle install
bundle exec jekyll serve --draft
```

### Vagrant

Because Ruby is quite complex to set up, I have included a Vagrantfile to automate the development environment. This is especially helpful on Windows. If you find this useful for creating your own websites, you are free to use it for your own projects.

1. Install [VirtualBox](https://www.virtualbox.org)
1. Install [Vagrant](https://www.vagrantup.com)
1. Open a shell
1. Change to the project directory (the directory that contains this file)
1. Start Vagrant with `vagrant up`. This will automatically download a Linux virtual machine, install Ruby and Jekyll and set up port forwarding
1. Enter the virtual machine with `vagrant ssh`
1. Within the virtual machine, type `jekyll serve --source /vagrant --host 0.0.0.0 --draft`
1. Open a web browser and go to [http://localhost:4000](http://localhost:4000)

You can edit the website with your favorite editor and changes will automatically be loaded when you refresh the browser. 
