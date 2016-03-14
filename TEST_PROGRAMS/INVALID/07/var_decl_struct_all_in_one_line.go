package main
func main() {
	var x [32]int
	var y [2] struct {x, y int}
	var x [1000]float64
	var a [3][5]int
	var b [2][2][2]float64  // same as [2]([2]([2]float64))
	var c[2][2][2]string // same as [2]([2]([2]float64))
	var x [3]int
	x[0] = 1
	x[1] = 2
	x[2] = 3
}
