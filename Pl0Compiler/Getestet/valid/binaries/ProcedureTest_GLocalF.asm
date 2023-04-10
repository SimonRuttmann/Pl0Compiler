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
	loadr	0
	dec	2
	dec	1
	loadc	101
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadc	401
	swap
	stores
	loadr	0
	call	f1
	loadr	0
	dec	2
	dec	1
	loads
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
f1	loadc	2
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
	dec	1
	loadc	111
	swap
	stores
	loadr	0
	dec	2
	dec	1
	loadc	211
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadc	411
	swap
	stores
	loadr	0
	call	g2
	loadr	0
	loads
	dec	2
	dec	1
	loads
	write
	loadr	0
	dec	2
	dec	1
	loads
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
g2	loadc	2
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
	loads
	dec	2
	dec	1
	loadc	121
	swap
	stores
	loadr	0
	dec	2
	dec	1
	loadc	321
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadc	421
	swap
	stores
	loadr	0
	loads
	loads
	dec	2
	dec	1
	loads
	write
	loadr	0
	dec	2
	dec	1
	loads
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
