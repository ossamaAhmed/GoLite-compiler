/* Anonymous struct. */

package main

func main() {
	var a struct {
		f1 int
		f2 float64
		f3 rune
	}

	a.f1 = 0
	a.f2 = 0.1
	a.f3 = 'W'
}
