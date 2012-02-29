default: compile run

compile:
	coffee -o lib/ -c src/lib
	coffee -o app/ -c src/app

run:
	node app/index.js
