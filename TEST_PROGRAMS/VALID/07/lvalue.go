// go lecture (6), slide 8
package main


func main () {
	var f int = 5
	var x[10] string
	var a int
	a, f = 0, 1
	x[a], a = 2, 5
	x[9], x[10] = 10, 20
	f, x[90], a = 3, 1, 4
	x[10], a, x[5] = 2, 1, 0
	x[10].x = 2
	x[10].g[10] = 1
	x.g[10] = 3
	x[0] = 2
}
