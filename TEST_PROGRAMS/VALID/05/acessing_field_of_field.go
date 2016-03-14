/* Field of a field. */

package main

type PolarPoint3D struct {
	r float64
	angle struct {
		tx, ty float64
	}
}

func main() {
	var p PolarPoint3D

	p.angle.tx = 90.
	p.angle.ty = 90.
}
