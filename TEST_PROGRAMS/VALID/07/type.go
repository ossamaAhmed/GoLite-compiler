// go lecture (6), slide 8
package main


func main () {
	type num int
	type point struct {
		x, y float64
	}
	type (
		num int
		point struct {
			x, y float64
		}
	)
	var x rune = '\n'
}
