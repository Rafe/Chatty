default: compile run

compile:
	coffee -o app/ -c src/app
	coffee -o app/assets/javascripts/ -c src/assets/javascripts/

run:
	node app/index.js
