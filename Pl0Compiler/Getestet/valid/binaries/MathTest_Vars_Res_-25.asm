	loadc	0	#RAM-INIT
	loadc	9
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
	dec	8
	loadc	5
	swap
	stores
	loadr	0
	dec	2
	dec	7
	loadc	1
	swap
	stores
	loadr	0
	dec	2
	dec	6
	loadc	2
	swap
	stores
	loadr	0
	dec	2
	dec	5
	loadc	3
	swap
	stores
	loadr	0
	dec	2
	dec	4
	loadc	3
	swap
	stores
	loadr	0
	dec	2
	dec	3
	loadc	1
	swap
	stores
	loadr	0
	dec	2
	dec	2
	loadc	2
	swap
	stores
	loadr	0
	dec	2
	dec	1
	loadc	3
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadr	0
	dec	2
	dec	8
	loads
	loadr	0
	dec	2
	dec	7
	loads
	loadr	0
	dec	2
	dec	6
	loads
	loadr	0
	dec	2
	dec	5
	loads
	mult
	add
	chs
	mult
	loadr	0
	dec	2
	dec	4
	loads
	loadr	0
	dec	2
	dec	3
	loads
	loadr	0
	dec	2
	dec	2
	loads
	loadr	0
	dec	2
	dec	1
	loads
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
