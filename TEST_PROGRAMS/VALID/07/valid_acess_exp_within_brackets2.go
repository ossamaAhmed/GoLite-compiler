package main

var x = 5
var y[10] int
var y[5] int
//var z[5+6] int
func main() {
	y[x] = 1000
	y[x+y[0]] = 1000
}
