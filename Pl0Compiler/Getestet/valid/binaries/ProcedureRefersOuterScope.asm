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
	loadc	1
	swap
	stores
	loadr	0
	call	someProc1
	loadc	1
	write
	loadc	10
	write
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
someProc1	loadc	0
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
	loads
	dec	2
	dec	0
	loadc	1
	loadr	0
	loads
	dec	2
	dec	0
	loads
	add
	swap
	stores
	loadr	0
	loads
	dec	2
	dec	0
	loads
	loadc	10
	cmplt
	jumpz	1
	loadr	0
	loads
	dec	2
	dec	0
	loads
	write
	loadr	0
	loads
	call	someProc1
1	nop
	loadr	0
	dec	1
	loads
	storer	0
	return
