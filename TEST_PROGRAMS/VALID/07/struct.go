// go lecture (6), slide 8
package main


func test(a, b point) point {
	var p point
	p.x = 1
	p.y = 2
	p.z = 3
	return point
}

func main () {
	type point struct {
		x, y, z int
	}
	var p point
	p.x = 1
	p.y = 2
	p.z = 3
}
