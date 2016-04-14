package main;
func main() {
	var x int;
	var y string;
	var z bool;
	z = false;
	y = "conditional doesn't work" /* string */;
	if z {
		y = "conditional 1" /* string */;
		var y int;
		y = 3 /* int */;
	} else if ( 3 /* int */ < 1 /* int */ ) /* bool */ {
		y = "conditional 2" /* string */;
	} else if ( 4 /* int */ > 1 /* int */ ) /* bool */ {
		y = "conditional 3" /* string */;
	}
	println(y)
}
