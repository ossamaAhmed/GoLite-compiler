// multiple var declaration specifying type only
package main

var x, a, b int
var y, d float64
var z, c string
var k, e rune
func main () {
	var x, a, b int
	var y, d float64
	var z, c string
	var k, e rune
	{
		var x, a, b int
		var y, d float64
		var z, c string
		var k, e rune
	}
}
