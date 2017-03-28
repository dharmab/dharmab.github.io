FROM jekyll/jekyll:latest

ADD Gemfile /srv/jekyll/
WORKDIR /srv/jekyll
RUN gem install bundler && bundle install

EXPOSE 4000

ADD . /srv/jekyll

CMD bundle exec jekyll serve --host 0.0.0.0
