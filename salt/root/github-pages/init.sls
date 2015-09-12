include:
  - ruby

# Jekyll requires a JavaScript runtime and node.js is the simplest and fastest
# to install on CentOS
nodejs:
  pkg.installed

github_pages:
  pkg.installed:
    - pkgs:
      # Nokogiri dependency
      - patch
  gem.installed:
    - name: github-pages
    - user: vagrant
    - require:
      - pkg: nodejs
      - sls: ruby
