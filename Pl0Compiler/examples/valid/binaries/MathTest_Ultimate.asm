	loadc	0	#RAM-INIT
	loadc	12
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
	dec	11
	loadc	1
	loadc	2
	add
	loadc	3
	add
	swap
	stores
	loadr	0
	dec	2
	dec	10
	loadc	1
	loadc	2
	loadc	3
	mult
	add
	swap
	stores
	loadr	0
	dec	2
	dec	9
	loadc	3
	loadc	2
	mult
	loadc	1
	add
	swap
	stores
	loadr	0
	dec	2
	dec	8
	loadc	1
	loadc	9
	loadc	3
	div
	add
	swap
	stores
	loadr	0
	dec	2
	dec	7
	loadc	9
	loadc	3
	div
	loadc	1
	add
	swap
	stores
	loadr	0
	dec	2
	dec	6
	loadc	1
	loadc	2
	add
	loadc	3
	mult
	swap
	stores
	loadr	0
	dec	2
	dec	5
	loadc	1
	chs
	loadc	2
	loadc	3
	mult
	add
	swap
	stores
	loadr	0
	dec	2
	dec	4
	loadc	1
	loadc	2
	loadc	3
	chs
	mult
	add
	loadc	1
	chs
	mult
	swap
	stores
	loadr	0
	dec	2
	dec	3
	loadc	1
	loadc	2
	chs
	chs
	chs
	chs
	loadc	3
	mult
	add
	swap
	stores
	loadr	0
	dec	2
	dec	2
	loadc	2
	chs
	chs
	chs
	chs
	loadc	3
	chs
	chs
	chs
	chs
	mult
	chs
	loadc	1
	chs
	mult
	swap
	stores
	loadr	0
	dec	2
	dec	1
	loadr	0
	dec	2
	dec	11
	loads
	loadr	0
	dec	2
	dec	10
	loads
	loadr	0
	dec	2
	dec	8
	loads
	loadr	0
	dec	2
	dec	6
	loads
	mult
	add
	chs
	mult
	loadr	0
	dec	2
	dec	5
	loads
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
	mult
	add
	add
	add
	loadc	1
	chs
	mult
	swap
	stores
	loadr	0
	dec	2
	dec	0
	loadr	0
	dec	2
	dec	1
	loads
	chs
	swap
	stores
	loadc	6
	write
	loadr	0
	dec	2
	dec	11
	loads
	write
	loadc	7
	write
	loadr	0
	dec	2
	dec	10
	loads
	write
	loadc	7
	write
	loadr	0
	dec	2
	dec	9
	loads
	write
	loadc	4
	write
	loadr	0
	dec	2
	dec	8
	loads
	write
	loadc	4
	write
	loadr	0
	dec	2
	dec	7
	loads
	write
	loadc	9
	write
	loadr	0
	dec	2
	dec	6
	loads
	write
	loadc	5
	write
	loadr	0
	dec	2
	dec	5
	loads
	write
	loadc	5
	write
	loadr	0
	dec	2
	dec	4
	loads
	write
	loadc	7
	write
	loadr	0
	dec	2
	dec	3
	loads
	write
	loadc	6
	write
	loadr	0
	dec	2
	dec	2
	loads
	write
	loadc	206
	write
	loadr	0
	dec	2
	dec	1
	loads
	write
	loadc	206
	chs
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
