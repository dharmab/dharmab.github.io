include:
  - ruby

# Jekyll requires a JavaScript runtime and node.js is the simplest and fastest
# to install on CentOS
nodejs:
  pkg.installed

github-pages:
  gem.installed:
    - user: vagrant
    - require:
      - pkg: nodejs
