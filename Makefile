SRC=main.fnl

run: out.fnl
	ls *fnl | entr make out.fnl &
	tic80 game.tic -code-watch out.fnl

out.fnl: $(SRC) ; cat $^ > $@
