	loadc	0	#RAM-INIT
	loadc	1
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
	loadr	0
	dec	2
	dec	0
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
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loads
	write
	loadr	0
	dec	1
	loads
	storer	0
	return
