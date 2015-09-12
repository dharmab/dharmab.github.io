{% set home = '/home/vagrant' -%}
{% set ruby_version = '2.2.2' -%}

git:
  pkg.installed:
    - name: git

rbenv:
  git.latest:
    - name: "https://github.com/sstephenson/rbenv.git"
    - target: '{{ home }}/.rbenv'
    - user: vagrant
    - require:
      - pkg: git
  file.append:
    - name: '{{ home }}/.bash_profile'
    - text: 
      - 'export PATH="$HOME/.rbenv/bin:$PATH"'
      - 'eval "$(rbenv init -)"'
  cmd.run:
    - name: rbenv install {{ ruby_version }}
    - user: vagrant
    - creates: '{{ home }}/.rbenv/versions/{{ ruby_version }}'
    - require:
      - git: rbenv
      - git: ruby_build
      - file: rbenv

rbenv_global:
  cmd.run:
    - name: rbenv global {{ ruby_version }}
    - user: vagrant
    - require:
      - cmd: rbenv

ruby_build:
  pkg.installed:
    - pkgs:
      # Build dependencies
      - readline-devel
      - openssl-devel
  git.latest:
    - name: "https://github.com/sstephenson/ruby-build.git"
    - target: '{{ home }}/.rbenv/plugins/ruby-build'
    - user: vagrant
    - require:
      - git: rbenv
      - pkg: ruby_build

