// Lucille's power func //
/* -------------------- */
package main

var x int
var z int

func f() {
	x = 10
	y := 2
	z = y

	for ; x > 0; x-- {
		z *= y
	}

	print(z)
}
