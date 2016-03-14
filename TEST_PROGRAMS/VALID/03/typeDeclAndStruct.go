// type declaration and struct
/* --------------- */
package main

type num int        // simple type alias
type point struct { // point is a struct
	x, y float64
}

type point struct {
	x, y float64
}

type (
	num   int
	point struct {
		x, y float64
	}
)

type (
	num   int
	point struct {
		x, y float64
	}
)

type point struct {
	x, y, z int
}

type num int
