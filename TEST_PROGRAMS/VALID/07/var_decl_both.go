// 1 var declaration specifying type and exp
package main

var x int = 1
var y float64 = 1.42
var z string = "h\re\n\tloooo"
var k rune = 'a'

func main() {
	var x int = 1
	var y float64 = 1.42
	var z string = "h\re\n\tloooo"
	var k rune = 'a'
	{
		var x int = 1
		var y float64 = 1.42
		var z string = "h\re\n\tloooo"
		var k rune = 'a'
	}
}
