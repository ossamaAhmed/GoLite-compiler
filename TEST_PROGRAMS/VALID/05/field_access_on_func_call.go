/* Field access directly on function call returning an object. */

package main

type PolarPoint3D struct {
	r float64
	angle struct {
		tx, ty float64
	}
}

func init() {
	var p PolarPoint3D

	p.r = 0.

	p.angle.tx = 0.
	p.angle.ty = 0.

	return p
}

func main() {
	print("Initial radius: ")
	println(init().r)
}
