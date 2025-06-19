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
	loadc	0
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadc	0
	swap
	stores
	loadr	0
	call	T1
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
T1	loadc	2
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
	loadc	30
	swap
	stores
	loadr	0
	loads
	dec	2
	dec	0
	loadc	30
	swap
	stores
	loadr	0
	dec	2
	dec	1
	loadc	30
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadc	30
	swap
	stores
	loadr	0
	call	T2
	loadr	0
	loads
	dec	2
	dec	1
	loads
	write
	loadr	0
	loads
	dec	2
	dec	0
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
T2	loadc	2
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
	loadc	20
	swap
	stores
	loadr	0
	loads
	loads
	dec	2
	dec	0
	loadc	20
	swap
	stores
	loadr	0
	dec	2
	dec	1
	loadc	20
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadc	20
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
	loads
	loads
	dec	2
	dec	0
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
