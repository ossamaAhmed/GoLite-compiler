package main
var i int
var U, V, W float64
var k = 0
var x, y float64 = -1, -2
var (
			i       int
				u, v, s = 2.0, 3.0, "bar"
	)
var re, im = complexSqrt(-1), 2
func main() {
	var i = 42             // i is int
	//var t, ok = x.(T)      // t is T, ok is bool
	var n = nil            // illegal
	{
		//var d = math.Sin(0.5)  // d is float64
		var i = 42             // i is int
		/*var t, ok = x.(T)      // t is T, ok is bool
		var n = nil            // illegal
		*/
	}
}
