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
	dec	1
	stores
	loadr	0
	dec	2
	dec	0
	loadc	1
	swap
	stores
	loadr	0
	call	fak1
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
fak1	loadc	0
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
	loads
	loadc	0
	cmpgt
	jumpz	1
	loadr	0
	loads
	dec	2
	dec	0
	loadr	0
	loads
	dec	2
	dec	0
	loads
	loadr	0
	loads
	dec	2
	dec	1
	loads
	mult
	swap
	stores
	loadr	0
	loads
	dec	2
	dec	1
	loadr	0
	loads
	dec	2
	dec	1
	loads
	loadc	1
	sub
	swap
	stores
	loadr	0
	loads
	call	fak1
	loadr	0
	loads
	dec	2
	dec	1
	loadr	0
	loads
	dec	2
	dec	1
	loads
	loadc	1
	add
	swap
	stores
1	nop
	loadr	0
	dec	1
	loads
	storer	0
	return
