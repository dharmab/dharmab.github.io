{% set home = '/home/vagrant' -%}
{% set rbenv_github_repo = 'https://github.com/sstephenson/rbenv.git' %}
{% set ruby_build_github_repo = 'https://github.com/sstephenson/ruby-build.git' %}
{% set ruby_version = '2.2.2' -%}

git:
  pkg.installed

rbenv:
  git.latest:
    - name: {{ rbenv_github_repo }}
    - target: '{{ home }}/.rbenv'
    - user: vagrant
  file.append:
    - name: '{{ home }}/.bash_profile'
    - text: 
      - 'export PATH="$HOME/.rbenv/bin:$PATH"'
      - 'eval "$(rbenv init -)"'

ruby-build:
  pkg.installed:
    - pkgs:
      # Build dependency
      - openssl-devel
  git.latest:
    - name: {{ ruby_build_github_repo }}
    - target: '{{ home }}/.rbenv/plugins/ruby-build'
    - user: vagrant
    - require:
      - git: rbenv

rbenv install {{ ruby_version }}:
  cmd.run:
    - user: vagrant
    - creates: '{{ home }}/.rbenv/versions/{{ ruby_version }}'
    - require:
      - git: ruby-build

rbenv global {{ ruby_version }}:
  cmd.run:
    - user: vagrant
    - require:
      - git: ruby-build

