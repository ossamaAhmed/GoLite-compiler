// multiple var declaration specifying type and exp
package main

var x, xx, xxx int = 1, 2, 3
var y, yy, yyy1 float64 = 1.42, 6.4, 0
var z, z2, z3 string = "h\re\n\tloooo", "z2", "z3"
var k, k2 rune = 'a', '\t'
var t, f = true, false

func main() {
	var x, xx, xxx int = 1, 2, 3
	var y, yy, yyy1 float64 = 1.42, 6.4, 0
	var z, z2, z3 string = "h\re\n\tloooo", "z2", "z3"
	var k, k2 rune = 'a', '\t'
	var t, f bool = true, false
	{
		var x, xx, xxx int = 1, 2, 3
		var y, yy, yyy1 float64 = 1.42, 6.4, 0
		var z, z2, z3 string = "h\re\n\tloooo", "z2", "z3"
		var k, k2 rune = 'a', '\t'
		var t, f bool = false,true
	}
}
