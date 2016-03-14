package main
type IntArray [16]int

type (
    Point struct { x, y float64; } // Some comment here; a semicolon should be inserted anyway
    Polar Point
)
/* Literals, golite 1.5; variable declarations, golite 2.4 */
    var x int 
    var (
        y, z = 0377, 0xff
        a, b, c float64 = 12., .12, 0.12
    )
    var esc_rune = '\n'
    var interp_string, raw_string = "hello\n\a\b\f\r\t\v\\'", `hello`
    var s string; var _p []Polar
    // Slice types, 2.7.2; Array types, 2.7.3
    
func main(a,b int) string {
        // println("hello world")

	return a
}

