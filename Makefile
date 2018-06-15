all:
	bundle install
	racc -o parser.rb grammar.y
	rake -B
