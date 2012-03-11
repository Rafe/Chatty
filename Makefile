default: compile spec run

compile:
	coffee -o lib/ -c src/*.coffee
	coffee -o example/ -c src/example
	coffee -o example/assets/javascripts/ -c src/example/assets/javascripts/

run:
	node example/index.js

clean:
	rm lib/*.js example/*.js example/assets/javascripts/*.js

spec:
	jasmine-node --coffee specs/

watch:
	watchr watch.rb

.PHONY: test
