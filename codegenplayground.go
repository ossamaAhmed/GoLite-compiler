package main


func main() {
	var x int
	var y string
	var z bool
	y="conditional doesn't work"
	if((2<1) && (3>1)){
		y= "conditional doesnt work"+"x"
	} else {
		y= "conditional works YAY"+"x"
	}
	println(y)
}
