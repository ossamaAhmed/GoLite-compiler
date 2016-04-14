// var declarations & assignments
/* --------------- */
package main

func f() {
	var x int
	var y = 42
	var z int = 1
	var x1, x2 int
	var y1, y2 = 42, 43
	var z1, z2 int = 1, 2
	var (
		x1, x2 int
		y1, y2     = 42, 43
		z1, z2 int = 1, 2
	)

	var xoey int
	var amiel float64
	var lucille bool
	var xal rune
	var s string
	var r rune

	var x []int
	x = append(x, 1)
	x = append(x, 2)
	x = append(x, 3)
	var x [3]int
	x[0] = 1
	x[1] = 2
	x[2] = 3

	x := "Test"
	r = 'r'

	// In GoLite for struct, we’ll use field access
	var p point
	p.x = 1
	p.y = 2
	p.z = 3

	// type casting, works like function calls
	x = int(y)
	x = x.f()
	x = num(y) // if num is a type struct

	var y num = num(x)

	x++
	x--
	x += 1

	x = 1

	a[i] = 23

	a[i] <<= 2
	i &^= 1 << n
	_ = x         // evaluate x but ignore it
	x, _ = f(), x // evaluate f() but ignore second result value
}
