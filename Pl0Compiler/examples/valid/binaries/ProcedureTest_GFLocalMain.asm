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
	loadc	100
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadc	400
	swap
	stores
	loadr	0
	call	f2
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
g1	loadc	2
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
	loadc	120
	swap
	stores
	loadr	0
	dec	2
	dec	1
	loadc	320
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadc	420
	swap
	stores
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
f2	loadc	2
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
	loadc	110
	swap
	stores
	loadr	0
	dec	2
	dec	1
	loadc	210
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadc	410
	swap
	stores
	loadr	0
	loads
	call	g1
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
