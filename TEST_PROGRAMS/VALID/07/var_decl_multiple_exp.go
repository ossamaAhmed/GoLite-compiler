// multiple var declaration specifying exp only
package main

var x, y, z = 1, 2, 3
func main () {
	var a, b, c = 2.64, 1, x
	if(true) {
		var e, f  = "hello world", ""
	}
	var k, m = '\r', 'x'
}
