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
	loadc	99
	write
	loadr	0
	dec	2
	dec	1
	loadc	0
	swap
	stores
3	nop
	loadr	0
	dec	2
	dec	1
	loads
	loadr	0
	dec	2
	dec	0
	loads
	cmple
	jumpz	4
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
	jump	3
4	nop
	loadc	99
	write
	loadr	0
	dec	2
	dec	1
	loadc	0
	swap
	stores
5	nop
	loadr	0
	dec	2
	dec	0
	loads
	loadr	0
	dec	2
	dec	1
	loads
	cmpgt
	jumpz	6
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
	jump	5
6	nop
	loadc	99
	write
	loadr	0
	dec	2
	dec	1
	loadc	0
	swap
	stores
7	nop
	loadr	0
	dec	2
	dec	0
	loads
	loadr	0
	dec	2
	dec	1
	loads
	cmpge
	jumpz	8
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
	jump	7
8	nop
	loadc	99
	write
	loadr	0
	dec	2
	dec	1
	loadc	0
	swap
	stores
9	nop
	loadr	0
	dec	2
	dec	0
	loads
	loadr	0
	dec	2
	dec	1
	loads
	cmpne
	jumpz	10
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
	jump	9
10	nop
	loadc	99
	write
	loadr	0
	dec	2
	dec	1
	loadc	0
	swap
	stores
11	nop
	loadr	0
	dec	2
	dec	1
	loads
	loadr	0
	dec	2
	dec	0
	loads
	cmpne
	jumpz	12
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
	jump	11
12	nop
	loadr	0
	dec	1
	loads
	storer	0
	return
