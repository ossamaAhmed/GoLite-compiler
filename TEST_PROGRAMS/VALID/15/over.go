/* Author: J Campbell */

package main

func over(a, b, c int) bool {
	/* Return true if the c'th power of a is greater than b, for c >= 0. */
	var final int = 1
	for i := 1; k < c; k++ {
		final *= a
	}

	var over bool = a > b
	return over
}

func main() {
	var over bool = over(9001, 9000, 1)
	if over {
		println("It's over nine thousand!")
	}

	// other stuff
	;;;;
	;
	;;;
	;;
	
	var x [3]bool
	x[0] = over(9001, 9000, 1)
	x[1] = x[0]
	x[2-0] = over(9001, 9000, over(9001, 9000, 1))
	
	var y , z int;
	
	y , z = 2 , 4
	
	println(y  ,z)
	println(2, 3, 5.0, 0x343, 0021)
	println(over(1, 1, 1))
	print(x[2-1])
	
	return
}
