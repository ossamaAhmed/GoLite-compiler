package main


func main() {
	var x int
	var y string
	var z bool
	y="conditional doesn't work"
	if( (1==1) && (1>3) && (4>1) && (5<1)){
		y= "conditional 1"
	} else if (3<1) {
		y= "conditional 2"
	}else if (4<1){
		y= "conditional 3"
	}

	println(y)
}
