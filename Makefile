.PHONY: build install test

build:
	bashly build

install:
	bashly build --env production
	sudo cp zxz /usr/local/bin/zxz

test:
	bashly build --env development
	bats test/zxz.bats
