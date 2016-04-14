package main


func main() {
	var x int
	var y string
	var z bool
	z=false
	y="conditional doesn't work"
	if(z){
		y= "conditional 1"
		var y int
		y=3
	} else if (3<1) {
		y= "conditional 2"
	}else if (4>1){
		y= "conditional 3"
	}
	
	println(y)
}
