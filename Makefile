.PHONY: develop

default: serve

build:
	docker build -t dharmab.github.io .

serve: build
	docker run -it --rm \
	-p 4000:4000 \
	-v $(shell pwd):/srv/jekyll \
	dharmab.github.io

draft: build
	docker run -it --rm \
	-p 4000:4000 \
	-v $(shell pwd):/srv/jekyll \
	dharmab.github.io \
	bundle exec jekyll serve --host 0.0.0.0 --draft
