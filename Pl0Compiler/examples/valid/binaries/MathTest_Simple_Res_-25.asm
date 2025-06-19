	loadc	0	#RAM-INIT
	loadc	0
	loadr	0
	add
	inc	2
	dup
	dec	1
	loadr	0
	swap
	stores
	dup
	storer	0
	stores
	loadc	5
	loadc	1
	loadc	2
	loadc	3
	mult
	add
	chs
	mult
	loadc	3
	loadc	1
	loadc	2
	loadc	3
	mult
	add
	add
	add
	write
	loadr	0
	dec	1
	loads
	storer	0
	return
