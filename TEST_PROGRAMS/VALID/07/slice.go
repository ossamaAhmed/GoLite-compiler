// go lecture (6), slide 8
package main


func main () {
	var x [] int
	x = append(x, 1)
	var y [] string
	y = append(y, "poop")
	q := append(y, "poo")
	q[5] = 5
}
