	loadc	0	#RAM-INIT
	loadc	3
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
	dec	2
	stores
	read
	loadr	0
	dec	2
	dec	1
	stores
	loadr	0
	call	ggt1
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
ggt1	loadc	0
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
3	nop
	loadr	0
	loads
	dec	2
	dec	2
	loads
	loadr	0
	loads
	dec	2
	dec	1
	loads
	cmpne
	jumpz	4
	loadr	0
	loads
	dec	2
	dec	2
	loads
	loadr	0
	loads
	dec	2
	dec	1
	loads
	cmpgt
	jumpz	1
	loadr	0
	loads
	dec	2
	dec	2
	loadr	0
	loads
	dec	2
	dec	2
	loads
	loadr	0
	loads
	dec	2
	dec	1
	loads
	sub
	swap
	stores
1	nop
	loadr	0
	loads
	dec	2
	dec	1
	loads
	loadr	0
	loads
	dec	2
	dec	2
	loads
	cmpgt
	jumpz	2
	loadr	0
	loads
	dec	2
	dec	1
	loadr	0
	loads
	dec	2
	dec	1
	loads
	loadr	0
	loads
	dec	2
	dec	2
	loads
	sub
	swap
	stores
2	nop
	jump	3
4	nop
	loadr	0
	loads
	dec	2
	dec	0
	loadr	0
	loads
	dec	2
	dec	2
	loads
	swap
	stores
	loadr	0
	dec	1
	loads
	storer	0
	return
