SRC=src/main.fnl

run: out.fnl
	ls src/*fnl | entr make out.fnl &
	tic80 game.tic -code-watch out.fnl

out.fnl: $(SRC) ; cat $^ > $@
