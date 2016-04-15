package main;

type point3d struct{
    x,y,z int;
}

func main() {
	x := true
	y := false

	if y {
		//Do nothing
	} else if x {
		//Do nothing
	} else {
		println(x)
	}
}
