	loadc	0	#RAM-INIT
	loadc	2
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
	read
	loadr	0
	dec	2
	dec	0
	stores
	loadc	99
	write
	loadr	0
	dec	2
	dec	1
	loadc	0
	swap
	stores
1	nop
	loadr	0
	dec	2
	dec	1
	loads
	loadr	0
	dec	2
	dec	0
	loads
	cmplt
	jumpz	2
	loadr	0
	dec	2
	dec	1
	loads
	write
	loadr	0
	dec	2
	dec	1
	loadr	0
	dec	2
	dec	1
	loads
	loadc	1
	add
	swap
	stores
	jump	1
2	nop
	loadr	0
	dec	1
	loads
	storer	0
	return
